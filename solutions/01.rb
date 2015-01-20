def seed_values_for(series_name)
  case series_name
    when 'fibonacci' then {1 => 1, 2 => 1}
    when 'lucas' then {1 => 2, 2 => 1}
  end
end

def compute_series(name, number)
  seed_values_for(name)[number] ||
  compute_series(name, number - 1) + compute_series(name, number - 2)
end

def series(name, number)
  if name == 'summed'
    compute_series('fibonacci', number) + compute_series('lucas', number)
  else
    compute_series(name, number)
  end
end