defmodule Dashboard.Accounts.Instructor do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dashboard.Accounts.Claim
  alias Dashboard.Calendars.Event
  alias Dashboard.Campuses.Campus

  schema "instructors" do
    field :background_color, :string
    field :email, :string
    field :external_id, :string
    field :external_provider, :string
    field :name, :string
    field :is_guest, :boolean

    has_many :claims, Claim
    many_to_many :campuses, Campus, join_through: "residences"
    many_to_many :events, Event, join_through: "claims"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(instructor, attrs) do
    # TODO: Validate colors for accessibility
    instructor
    |> cast(attrs, [:name, :email, :external_id, :external_provider, :background_color])
    |> unique_constraint([:external_id, :external_provider])
    |> validate_required([:name])
    |> check_constraint(
      :is_guest,
      name: :require_instructor_info_or_guest,
      message: "Non-guest instructors require email, external_provider and external_id."
    )
  end
end
