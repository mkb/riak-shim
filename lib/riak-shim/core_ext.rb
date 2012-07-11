## taken from active support, but don't want all the baggage...
## converts camel case to all lower case name delimited by underscores
## for bucket name prettyness
class String
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end