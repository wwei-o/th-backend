describe SlotModule do 
  let (:user) { 
    User.create(
      name: 'John',
      email: 'doe@mail.com',
      role: :tourOperator
    )
  }

  describe 'Check slot availablity for user' do
    it 'return slot availability' do
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
      
      result = SlotModule.available?(user, Time.zone.parse('2024-05-03'), Time.zone.parse('2024-05-07').end_of_day)
      expect(result).to eq(false)

      result = SlotModule.available?(user, Time.zone.parse('2024-06-06'), Time.zone.parse('2024-06-07').end_of_day)
      expect(result).to eq(true)
    end
  end

end
