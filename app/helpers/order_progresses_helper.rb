module OrderProgressesHelper
  
  def progresses_summary(progresses)
    if progresses.empty?
      "没有记录"
    else
      "#{progresses.size}条记录"
    end
  end
  
end
