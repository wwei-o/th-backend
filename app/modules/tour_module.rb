module TourModule
  def self.create_tour(
    user,
    tourTitle: nil,
    tourDesc: nil,
    tourMode: :oneTime,
    repeatBy: nil, # day, week, month
    repeatDay: nil, 
    repeatWeek: nil,
    startDate: nil,
    endDate: nil,
    startTime: nil,
    endTime: nil,
    durationDay: nil
  )
    tour = user.tours.create(
      title: tourTitle,
      desc: tourDesc,
      mode: tourMode,
      status: :active
    )

    case tourMode
      when :oneTime
        create_one_time_slot(user, tour, startDate, endDate, startTime, endTime)
      when :recurring
        duration = 1
        if durationDay
          duration = durationDay - 1
        end

        create_recurring_slots(
          user,
          tour,
          repeatBy,
          repeatDay,
          repeatWeek,
          startDate,
          endDate,
          startTime,
          endTime,
          duration
        )
      else
        "Error: Invalid tour mode"
    end
  end

  def self.create_one_time_slot(user, tour, startDate, endDate, startTime, endTime) 
    if SlotModule.available?(user, startDate, endDate) 
      user.slots.create(
        tour: tour,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime
      )
    end
  end

  def self.create_custom_slots_tour(
    user,
    tourTitle: nil,
    tourDesc: nil,
    slotSettings: []
  )
    tour = user.tours.create(
      title: tourTitle,
      desc: tourDesc,
      mode: :recurring,
      status: :active
    )

    slotSettings.each do |setting|
      if SlotModule.available?(user, setting[:startDate], setting[:endDate]) 
        user.slots.create(
          tour: tour,
          startDate: setting[:startDate],
          endDate: setting[:endDate],
          startTime: setting[:startTime],
          endTime: setting[:endTime]
        )
      end
    end
  end

  def self.create_recurring_slots(
    user,
    tour,
    repeatBy,
    repeatDay,
    repeatWeek,
    startDate,
    endDate,
    startTime,
    endTime,
    durationDay
  )
    case repeatBy
      when 'day'
        dayDiff = ((endDate - startDate).to_i / 86400).ceil
        for a in 0..dayDiff do
          slotStart = startDate + a.days
          slotEnd = slotStart.end_of_day
          if SlotModule.available?(user, slotStart, slotEnd) 
            user.slots.create(
              tour: tour,
              startDate: slotStart,
              endDate: slotEnd,
              startTime: startTime,
              endTime: endTime
            )
          end
        end

      when 'week'
        (startDate.to_date..endDate.to_date).select { |date|
          if date.wday == repeatDay
            slotStart = date
            slotEnd = date + durationDay.days
            if SlotModule.available?(user, slotStart, slotEnd) 
              user.slots.create(
                tour: tour,
                startDate: slotStart,
                endDate: slotEnd,
                startTime: startTime,
                endTime: endTime
              )
            end
          end
        }

      when 'month'
        (startDate.to_date..endDate.to_date).select { |date|
          if repeatWeek
            weekOfMonth = week_of_month_for_date(date)
            if (weekOfMonth == repeatWeek && date.wday == repeatDay)
              slotStart = date
              slotEnd = date + durationDay.days
              if SlotModule.available?(user, slotStart, slotEnd) 
                user.slots.create(
                  tour: tour,
                  startDate: slotStart,
                  endDate: slotEnd,
                  startTime: startTime,
                  endTime: endTime
                )
              end
            end
          else
            if date.day == repeatDay
              slotStart = date
              slotEnd = date + durationDay.days
              if SlotModule.available?(user, slotStart, slotEnd) 
                user.slots.create(
                  tour: tour,
                  startDate: slotStart,
                  endDate: slotEnd,
                  startTime: startTime,
                  endTime: endTime
                )
              end
            end
          end
        }
      when 'year'

      else
        "Error: invalid tour type"
    end
  end

  def self.week_of_month_for_date(date)
    week_of_target_date = date.strftime("%U").to_i
    week_of_beginning_of_month = date.beginning_of_month.strftime("%U").to_i
    week_of_target_date - week_of_beginning_of_month + 1
  end
end