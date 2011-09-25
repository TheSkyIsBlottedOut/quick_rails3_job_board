class Object
  def wordy?
    self.to_s =~ /\w+/
  end
end