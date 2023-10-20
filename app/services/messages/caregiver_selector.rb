module Messages
  class CaregiverSelector
    def initialize(health_center)
      @health_center = health_center
    end

    attr_reader :health_center

    def call
      # Find last message, then I have the last caregiver assigned (not really T_T)
      HealthCenter.where(id: health_center.id).joins(:caregivers).last.caregivers.last
    end
  end
end
