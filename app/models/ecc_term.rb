class EccTerm < ApplicationRecord
  belongs_to :ecc_type

  has_many :ecc_factors, dependent: :destroy

  accepts_nested_attributes_for :ecc_factors,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def get_valid_timestamps(timestamps)
    ecc_factors.inject(timestamps) do |t, ecc_factor|
      ecc_factor.get_valid_timestamps(t)
    end
  end
end
