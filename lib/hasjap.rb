# encoding: UTF-8

class String
  def hasjap?
    !!(self =~ /\p{Han}|\p{Katakana}|\p{Hiragana}/)
  end
end
