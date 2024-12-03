class MethodCache
  def initialize(max_size)
    @max_size = max_size
    @cache = {}
    @access_order = []
  end

  def cache(key)
    if @cache.key?(key)
      # Якщо ключ вже є в кеші, оновлюємо порядок доступу
      @access_order.delete(key)
      @access_order.push(key)
      return @cache[key]
    end

    # Якщо ключа немає в кеші, викликаємо блок і додаємо його в кеш
    value = yield
    @cache[key] = value
    @access_order.push(key)

    # Перевіряємо, чи перевищуємо максимальний розмір
    if @cache.size > @max_size
      oldest_key = @access_order.shift
      @cache.delete(oldest_key)
    end

    value
  end
end

# Приклад використання
cache = MethodCache.new(3)

puts cache.cache(:a) { 1 } # Додаємо :a -> 1
puts cache.cache(:b) { 2 } # Додаємо :b -> 2
puts cache.cache(:c) { 3 } # Додаємо :c -> 3

puts cache.cache(:a) { 99 } # Отримуємо кешований :a -> 1
puts cache.cache(:d) { 4 }  # Додаємо :d -> 4, видаляється :b (найстаріший)

puts cache.cache(:b) { 5 }  # Додаємо :b -> 5, видаляється :c (найстаріший)
