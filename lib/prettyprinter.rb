module PrettyPrinter
  def pretty_int val
    if val < 10 then
      return "0#{val}"
    end
    "#{val}"
  end
end

