describe TourModule do
  let (:user) { 
    User.create(
      name: 'John',
      email: 'doe@mail.com',
      role: :tourOperator
    )
  }

  describe 'Create one time tour' do
    it 'successfully create tour' do
      TourModule.create_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        tourMode: :oneTime,
        startDate: Time.zone.parse('2024-05-01'),
        endDate: Time.zone.parse('2024-05-05').end_of_day,
        startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
        endTime: Time.zone.parse('2024-05-01T17:00:00Z')
      )

      user.reload

      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(1)
      expect(user.tours[0].slots.length).to eq(1)
    end
  end

  describe 'Create recurring tour' do
    it 'successfully create daily recurring tour' do
      TourModule.create_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        tourMode: :recurring,
        repeatBy: 'day',
        startDate: Time.zone.parse('2024-05-01'),
        endDate: Time.zone.parse('2024-05-05').end_of_day,
        startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
        endTime: Time.zone.parse('2024-05-01T17:00:00Z')
      )

      user.reload

      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(5)
      expect(user.tours[0].slots[0].startDate).to eq(Time.zone.parse('2024-05-01'))
      expect(user.tours[0].slots[1].startDate).to eq(Time.zone.parse('2024-05-02'))
      expect(user.tours[0].slots[2].startDate).to eq(Time.zone.parse('2024-05-03'))
      expect(user.tours[0].slots[3].startDate).to eq(Time.zone.parse('2024-05-04'))
      expect(user.tours[0].slots[4].startDate).to eq(Time.zone.parse('2024-05-05'))
    end

    it 'successfully create weekly recurring tour' do
      TourModule.create_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        tourMode: :recurring,
        repeatDay: 1,
        repeatBy: 'week',
        startDate: Time.zone.parse('2024-05-01'),
        endDate: Time.zone.parse('2024-05-31').end_of_day,
        startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
        endTime: Time.zone.parse('2024-05-01T17:00:00Z'),
        durationDay: 3
      )

      user.reload
      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(4)
      expect(user.tours[0].slots[0].startDate).to eq(Time.zone.parse('2024-05-06'))
      expect(user.tours[0].slots[1].startDate).to eq(Time.zone.parse('2024-05-13'))
      expect(user.tours[0].slots[2].startDate).to eq(Time.zone.parse('2024-05-20'))
      expect(user.tours[0].slots[3].startDate).to eq(Time.zone.parse('2024-05-27'))
    end

    it 'successfully create monthly recurring tour by date' do
      TourModule.create_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        tourMode: :recurring,
        repeatDay: 1,
        repeatBy: 'month',
        startDate: Time.zone.parse('2024-05-01'),
        endDate: Time.zone.parse('2024-08-31').end_of_day,
        startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
        endTime: Time.zone.parse('2024-05-01T17:00:00Z'),
        durationDay: 5
      )

      user.reload
      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(4)
      expect(user.tours[0].slots[0].startDate).to eq(Time.zone.parse('2024-05-01'))
      expect(user.tours[0].slots[1].startDate).to eq(Time.zone.parse('2024-06-01'))
      expect(user.tours[0].slots[2].startDate).to eq(Time.zone.parse('2024-07-01'))
      expect(user.tours[0].slots[3].startDate).to eq(Time.zone.parse('2024-08-01'))
    end

    it 'successfully create monthly recurring tour by weekcount & weekday' do
      TourModule.create_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        tourMode: :recurring,
        repeatDay: 5,
        repeatWeek: 2,
        repeatBy: 'month',
        startDate: Time.zone.parse('2024-05-01'),
        endDate: Time.zone.parse('2024-08-31').end_of_day,
        startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
        endTime: Time.zone.parse('2024-05-01T17:00:00Z'),
        durationDay: 5
      )

      user.reload
      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(4)
      expect(user.tours[0].slots[0].startDate).to eq(Time.zone.parse('2024-05-10'))
      expect(user.tours[0].slots[1].startDate).to eq(Time.zone.parse('2024-06-07'))
      expect(user.tours[0].slots[2].startDate).to eq(Time.zone.parse('2024-07-12'))
      expect(user.tours[0].slots[3].startDate).to eq(Time.zone.parse('2024-08-09'))
    end
  
    it 'successfully create custom recurring tour' do
      TourModule.create_custom_slots_tour(
        user,
        tourTitle: 'Sample',
        tourDesc: '',
        slotSettings: [
          {
            startDate: Time.zone.parse('2024-05-01'),
            endDate: Time.zone.parse('2024-05-05').end_of_day,
            startTime: Time.zone.parse('2024-05-01T09:00:00Z'),
            endTime: Time.zone.parse('2024-05-01T17:00:00Z'),
          },
          {
            startDate: Time.zone.parse('2024-06-02'),
            endDate: Time.zone.parse('2024-06-06').end_of_day,
            startTime: Time.zone.parse('2024-07-01T09:00:00Z'),
            endTime: Time.zone.parse('2024-07-01T17:00:00Z'),
          },
          {
            startDate: Time.zone.parse('2024-07-03'),
            endDate: Time.zone.parse('2024-07-07').end_of_day,
            startTime: Time.zone.parse('2024-07-01T09:00:00Z'),
            endTime: Time.zone.parse('2024-07-01T17:00:00Z'),
          }
        ]
      )

      user.reload
      expect(user.tours.length).to eq(1)
      expect(user.slots.length).to eq(3)
      expect(user.tours[0].slots[0].startDate).to eq(Time.zone.parse('2024-05-01'))
      expect(user.tours[0].slots[1].startDate).to eq(Time.zone.parse('2024-06-02'))
      expect(user.tours[0].slots[2].startDate).to eq(Time.zone.parse('2024-07-03'))
    end
  end
end