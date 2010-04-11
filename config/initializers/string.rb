class String

  def random(*opts)
    str = ''
    options = {:limit => 12, :extra_chars => false, :random_length => false}.merge(opts.extract_options!)
    chars = '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    chars << '%#$@!_-?<>' if options[:extra_chars]

    limit = (options[:limit]-2) + rand(4) if options[:random_length]
    limit ||= options[:limit]

    limit.to_i.times {|i| str << chars[rand(chars.length-1)] }

    return str
  end

end