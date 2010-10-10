# Задача программы - нахождения вероятности того, что при броске n m - гранных
# кубиков, сумма получиться k.
# Основная идея программы:
# Уменьшение объемов данных для расчета. Это достигается двумя путями:
#  1) Запоминание вычисленного значения
#  2) При четных n можно вычислить вероятности выпадения соответствующих сумм
#    только для n / 2 кубиков. Затем, воспользовавшись формулами для расчета
#    вероятностей, найти вероятность для n.

class ProbabilityCalculation
  @@remembered = Array.new
  class << self

    # Расчет для нечетных значений n
    def odd(n, m, k)
      # Проверяем, было ли необходимое вычисленно ранее
      if !@@remembered[n].nil? and !@@remembered[n][k].nil?
        return @@remembered[n][k]
      end

      sum_of_prob = 0
      (1..m).each do |i|
        sum_of_prob += even(n - 1, m, k - i)
      end
      (1.0 / m) * sum_of_prob
      # запоминаем результат для n и k
      @@remembered[n] = Hash.new if @@remembered[n].nil?
      @@remembered[n][k] = (1.0 / m) * sum_of_prob
      @@remembered[n][k]
    end

    # Расчет для четных значений n
    def even(n, m, k)
      # Проверяем, было ли необходимое вычисленно ранее
      if !@@remembered[n].nil? and !@@remembered[n][k].nil?
        return @@remembered[n][k]
      end
      return 0 if k > (n * m) or k < n
      prob = Hash.new
      ((n/2) .. (k - 1)).each do |i|
        prob[i] =  probability(n / 2, m, i)
      end
      rez = 0
      prob.each_key do |i|
        rez += prob[i].to_f * prob[k - i ].to_f
      end
      # запоминаем результат для n и k
      @@remembered[n] = Hash.new if @@remembered[n].nil?
      @@remembered[n][k] = rez
      rez
    end

    # Метод для расчета вероятности выпадения на n m - гранных кубиках k
    def probability(n, m, k)
      return 0 if k > (n * m) or k < n
      return (1.0 / m) if n == 1
      if n % 2 == 1
        odd(n, m, k)
      else
        even(n, m, k)
      end
    end

  end
end

k, n, m = *ARGV.map{|e| e.to_i}
puts ProbabilityCalculation.probability(n,m,k)

