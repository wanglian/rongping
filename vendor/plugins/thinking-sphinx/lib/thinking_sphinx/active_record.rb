require 'thinking_sphinx/active_record/delta'
require 'thinking_sphinx/active_record/search'
require 'thinking_sphinx/active_record/has_many_association'

module ThinkingSphinx
  # Core additions to ActiveRecord models - define_index for creating indexes
  # for models. If you want to interrogate the index objects created for the
  # model, you can use the class-level accessor :sphinx_indexes.
  #
  module ActiveRecord
    def self.included(base)
      base.class_eval do
        class_inheritable_array :sphinx_indexes
        class << self
          # Allows creation of indexes for Sphinx. If you don't do this, there
          # isn't much point trying to search (or using this plugin at all,
          # really).
          #
          # An example or two:
          #
          #   define_index
          #     indexes :id, :as => :model_id
          #     indexes name
          #   end
          #
          # You can also grab fields from associations - multiple levels deep
          # if necessary.
          #
          #   define_index do
          #     indexes tags.name, :as => :tag
          #     indexes articles.content
          #     indexes orders.line_items.product.name, :as => :product
          #   end
          #
          # And it will automatically concatenate multiple fields:
          #
          #   define_index do
          #     indexes [author.first_name, author.last_name], :as => :author
          #   end
          #
          # The #indexes method is for fields - if you want attributes, use
          # #has instead. All the same rules apply - but keep in mind that
          # attributes are for sorting, grouping and filtering, not searching.
          #
          #   define_index do
          #     # fields ...
          #     
          #     has created_at, updated_at
          #   end
          #
          # One last feature is the delta index. This requires the model to
          # have a boolean field named 'delta', and is enabled as follows:
          #
          #   define_index do
          #     # fields ...
          #     # attributes ...
          #     
          #     set_property :delta => true
          #   end
          #
          # Check out the more detailed documentation for each of these methods
          # at ThinkingSphinx::Index::Builder.
          # 
          def define_index(&block)
            return unless ThinkingSphinx.define_indexes?
            
            self.sphinx_indexes ||= []
            index = Index.new(self, &block)
            
            self.sphinx_indexes << index
            unless ThinkingSphinx.indexed_models.include?(self.name)
              ThinkingSphinx.indexed_models << self.name
            end
            
            if index.delta?
              before_save   :toggle_delta
              after_commit  :index_delta
            end
            
            after_destroy :toggle_deleted
            
            index
          end
          alias_method :sphinx_index, :define_index
          
          def sphinx_index_options
            sphinx_indexes.last.options
          end
          
          # Generate a unique CRC value for the model's name, to use to
          # determine which Sphinx documents belong to which AR records.
          # 
          # Really only written for internal use - but hey, if it's useful to
          # you in some other way, awesome.
          # 
          def to_crc32
            result = 0xFFFFFFFF
            self.name.each_byte do |byte|
              result ^= byte
              8.times do
                result = (result >> 1) ^ (0xEDB88320 * (result & 1))
              end
            end
            result ^ 0xFFFFFFFF
          end
          
          def to_crc32s
            (subclasses << self).collect { |klass| klass.to_crc32 }
          end
          
          def source_of_sphinx_index
            possible_models = self.sphinx_indexes.collect { |index| index.model }
            return self if possible_models.include?(self)

            parent = self.superclass
            while !possible_models.include?(parent) && parent != ::ActiveRecord::Base
              parent = parent.superclass
            end

            return parent
          end
        end
      end
      
      base.send(:include, ThinkingSphinx::ActiveRecord::Delta)
      base.send(:include, ThinkingSphinx::ActiveRecord::Search)
      
      ::ActiveRecord::Associations::HasManyAssociation.send(
        :include, ThinkingSphinx::ActiveRecord::HasManyAssociation
      )
      ::ActiveRecord::Associations::HasManyThroughAssociation.send(
        :include, ThinkingSphinx::ActiveRecord::HasManyAssociation
      )
    end
    
    def in_core_index?
      self.class.search_for_id(
        self.sphinx_document_id,
        "#{self.class.source_of_sphinx_index.name.underscore.tr(':/\\', '_')}_core"
      )
    end
    
    def toggle_deleted
      return unless ThinkingSphinx.updates_enabled? && ThinkingSphinx.sphinx_running?
      
      config = ThinkingSphinx::Configuration.instance
      client = Riddle::Client.new config.address, config.port
      
      client.update(
        "#{self.class.sphinx_indexes.first.name}_core",
        ['sphinx_deleted'],
        {self.sphinx_document_id => 1}
      ) if self.in_core_index?
      
      client.update(
        "#{self.class.sphinx_indexes.first.name}_delta",
        ['sphinx_deleted'],
        {self.sphinx_document_id => 1}
      ) if ThinkingSphinx.deltas_enabled? &&
        self.class.sphinx_indexes.any? { |index| index.delta? } &&
        self.delta?
    rescue ::ThinkingSphinx::ConnectionError
      # nothing
    end
    
    def sphinx_document_id
      (self.id * ThinkingSphinx.indexed_models.size) +
        ThinkingSphinx.indexed_models.index(self.class.source_of_sphinx_index.name)
    end
  end
end
