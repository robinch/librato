class Hash
  EXCEPT = ->(object, *keys) do
    case object
    when Hash
      object.inject({}) { |hash, (k, v)| keys.include?(k) ? hash : hash.merge(k => EXCEPT.call(v, *keys)) }
    when Array
      object.map { |object| EXCEPT.call(object, *keys) }
    else
      object
    end
  end

  def deep_except(*keys)
    EXCEPT.call(self, *keys)
  end

  def symbolize_keys
    inject({}) { |hash, (k, v)| hash.merge(k.to_sym => v) }
  end
end

