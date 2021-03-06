# == Schema Information
#
# Table name: releases
#
#  id          :integer          not null, primary key
#  game_id     :integer
#  platform_id :integer
#  name        :string(255)
#  market      :string(255)
#  released_on :date
#  created_at  :datetime
#  updated_at  :datetime
#

class Release < ActiveRecord::Base
  belongs_to      :game
  belongs_to      :platform

  has_many      :developer_company_releases,
    :class_name => "CompanyRelease::Developer"
  has_many      :developers,
    :through => :developer_company_releases,
    :source => :company

  has_many      :publisher_company_releases,
    :class_name => "CompanyRelease::Publisher"
  has_many      :publishers,
    :through => :publisher_company_releases,
    :source => :company

  MARKETS = [
    MARKET_US = "US",
    MARKET_UK = "UK",
    MARKET_JAPAN = "Japan",
    MARKET_AUSTRALIA = "Australia"
  ]

  validates :market,
    :inclusion => {
      :in => MARKETS
    }

  validates :game_id,
    :presence => true
  validates :platform_id,
    :presence => true,
    :uniqueness => {
      :scope => [
        :game_id,
        :name,
        :market
      ]
    }

  def name
    read_attribute(:name) || game.try(:name)
  end
end
