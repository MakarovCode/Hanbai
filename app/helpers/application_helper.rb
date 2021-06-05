module ApplicationHelper
  def humanize_duration secs
    [[60, :segundos], [60, :minutos], [24, :horas], [1000, :"días"]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}" unless name == :segundos
      end
    }.compact.reverse.join(' ')
  end
end
