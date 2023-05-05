defmodule Candone.DateUtils do

  def get_work_week(date) do
    current_year = Date.utc_today
    beggining_date = Date.new!(current_year.year, 1, 1)
    start_day = Date.day_of_week(beggining_date)
    current_day = Date.day_of_year(NaiveDateTime.to_date(date))
    adjusted = current_day + start_day
    trunc(adjusted / 7)
  end

  def get_current_week() do
    get_work_week(NaiveDateTime.utc_now)
  end

end
