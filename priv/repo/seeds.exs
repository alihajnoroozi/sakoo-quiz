alias Mafia.Repo
# alias Survey.Settings.Setting

# Seeding User table
admin = System.get_env("ADMIN_NUMBER")
dup_admin = Mafia.Accounts.get_user_by_mobile!(admin)
if dup_admin do
  Mafia.Accounts.update_user(dup_admin, %{ is_admin: true })
  IO.inspect("User Already Exists :( But I Gave Him Admin Permission :)")
else
  Mafia.Accounts.create_user(%{
    mobile: admin,
    is_admin: true
  })
  IO.inspect("User Added In Admin Role :)")
end
