module Admin::PermissionsHelper
  def permissions
    { view: "View",
    "create tickets" => "Create Tickets",
    "edit ticket" => "Edit Ticket",
    "delete ticket" => "Delete Ticket" }
  end
end
