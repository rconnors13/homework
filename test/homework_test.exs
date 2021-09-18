defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
#  use ExUnit.CaseTemplate
#  import Plug.Conn
#  import Phoenix.ConnTest
#  import Wallaby.SettingsTestHelpers

  # Start hound session and destroy when tests are run
  hound_session()

  # TODO: cleanup - move variables and functions to helper module
  defp login_url do
    "https://the-internet.herokuapp.com/login"
  end

  defp secure_url do
    "https://the-internet.herokuapp.com/secure"
  end

  defp login_page do
    navigate_to login_url()
  end

  defp login_form(user, pass) do
    form = find_element(:id, "login")
    username = find_within_element(form, :id, "username")
    password = find_within_element(form, :id, "password")
    submit = find_within_element(form, :class, "radius")

    username |> fill_field(user)
    password |> fill_field(pass)
    submit |> click()
  end

  defp get_notification do
    notification = find_element(:id, "flash-messages")
    notification_message = find_within_element(notification, :id, "flash")
    _notification_text = visible_text(notification_message)
  end

  defp valid_user do
    "tomsmith"
  end

  defp valid_password do
    "SuperSecretPassword!"
  end

  @tag dont_run: false
  test "goes to google" do
    navigate_to "http://google.com"
  end

  # Form Authentication tests
  @tag form_auth_tests: true
  test "form authentication login and logout is successful" do
    login_page()

    login_form(valid_user(), valid_password())

    assert get_notification() =~ "You logged into a secure area!"
    assert current_url() == secure_url()

    logout = find_element(:class, "example")
    logout_text = find_within_element(logout, :link_text, "Logout")

    logout_text |> click()

    assert current_url() == login_url()
  end

  @tag form_auth_tests: true
  test "form authentication username is invalid" do
    login_page()

    login_form("baduser", valid_password())

    assert get_notification() =~ "Your username is invalid!"
    assert current_url() == login_url()
  end

  @tag form_auth_tests: true
  test "form authentication password is invalid" do
    login_page()

    login_form(valid_user(), "badpass")

    assert get_notification() =~ "Your password is invalid!"
    assert current_url() == login_url()
  end

  @tag form_auth_tests: true
  test "secure area is not accessible without login" do
    navigate_to "https://the-internet.herokuapp.com/secure"

    assert get_notification() =~ "You must login to view the secure area"
    assert current_url() == login_url()
  end

  # Multiple windows tests
  @tag multi_windows_tests: true
  test "link opens new window" do
    navigate_to "https://the-internet.herokuapp.com/windows"

    link = find_element(:class, "example")
    click_here = find_within_element(link, :link_text, "Click Here")
    click_here |> click()

    #TODO: sleep or focus change to new window?
#    Process.sleep(1000)
#    assert current_url() == "https://the-internet.herokuapp.com/windows/new"
#    assert page_title() == "New Window"
#    assert_visited("https://the-internet.herokuapp.com/windows/new")
  end

  # TODO: research html status testing
#  test "forgot password request successful" do
#    navigate_to "https://the-internet.herokuapp.com/forgot_password"
#
#    form = find_element(:id, "forgot_password")
#    email = find_within_element(form, :id, "email")
#    retrieve_email = find_within_element(form, :class, "radius")
#
#    email |> fill_field("test@the-internet.com")
#    retrieve_email |> click()
#
#    assert html_response(500)
#  end
end
