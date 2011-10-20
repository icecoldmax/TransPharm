def show_regex(a, re)
  if a =~ re
    "#{$`}<<#{$&}<<#{$'}"
  else
    "no match"
  end
end