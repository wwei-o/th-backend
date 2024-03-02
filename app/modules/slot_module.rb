module SlotModule
  def self.available?(user, newStartDate, newEndDate)
    # TODO: find one instead of finding the full existing list
    existing = Slot.where(
      "(? BETWEEN startDate AND endDate OR ? BETWEEN startDate AND endDate) AND user_id = ?", 
      newStartDate, 
      newEndDate, 
      user.id
    )
    if existing.length > 0
      return false
    else
      return true
    end
  end
end