defmodule MafiaWeb.SignInLive do
  use MafiaWeb, :live_view
  require Logger
  alias Mafia.Accounts.User
  alias Mafia.Accounts.Sessions

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    changeset_verify =
      %User{}
      |> User.changeset_verify(%{
        "phone" => nil
      })

    #    changeset = User.changeset(%User{})
    {:ok,
     assign(socket,
       step: 1,
       error_message: "",
       page_title: "ورود به حساب کاربری",
       timer: 0,
       mobile: nil,
       is_valid_mobile: false,
       is_valid_code: false,
       mobile_empty: true,
       code_empty: true,
       mobile_changeset: changeset_verify,
       expanded: false
      )}
  end

  @impl true
  def handle_event("send_confirmation", %{"mobile" => mobile}, socket) do
    socket = assign(socket, mobile: mobile, timer: 120, step: 2)
    send(self(), {:send_code, mobile})
    {:noreply, socket}
  end

  def handle_event("confirmation", %{"confirmation_code" => confirmation_code}, socket) do
    Logger.info(confirmation_code)
    Logger.info(socket.assigns.mobile)
    mobile = socket.assigns.mobile

    case PasswordlessAuth.verify_code(mobile, confirmation_code) do
      :ok ->
        Logger.info("Code has been deleted")

        user = case Mafia.Accounts.get_user_by_mobile!(mobile) do
          result = %{} ->
            Logger.info("User already exists")
            result
          nil ->
            Logger.info("New user created")
            {:ok, user} = Mafia.Accounts.create_user(%{mobile: mobile, is_admin: false})
            user
        end
        if user do
          PasswordlessAuth.remove_code(mobile)
          Logger.info("Success")
          {:noreply,
            redirect(socket,
              to: Routes.session_path(socket, :login, user.id, user.is_admin, user.mobile)
            )}
        end
      {:error, :incorrect_code} ->
        {:noreply,
         assign(socket, code_empty: true)
         |> put_flash("error", "کد تأیید اشتباه است، در صورت نیاز ارسال مجدد کد را بزنید.")}
    end

    #      Logger.info(is_nil(Survey.Accounts.get_user_by_phone!(mobile)))
    #      {:ok, token, claims} = Survey.Guardian.encode_and_sign(%{id: mobile})
    #      Logger.info(token)
    #      Logger.info(claims)

    #      {:ok, resource, claims} = Survey.Guardian.resource_from_token(token)
    #      Logger.info(resource)
  end

  @spec handle_info(
          :tick,
          atom
          | %{:assigns => atom | %{:timer => any, optional(any) => any}, optional(any) => any}
        ) :: {:noreply, atom | %{:assigns => atom | map, optional(any) => any}}
  def handle_info(:tick, socket) do
    socket =
      if socket.assigns.timer > 0 do
        assign(socket, :timer, socket.assigns.timer - 1)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("resend", _params, socket) do
    socket = assign(socket, timer: 120)
    send(self(), {:send_code, socket.assigns.mobile})
    {:noreply, socket |> clear_flash("error")}
  end

  def handle_info({:send_code, mobile}, socket) do
    changeset_verify =
      %User{}
      |> User.changeset_verify(%{
        "mobile" => mobile
      })

    if changeset_verify.valid? do
      code = PasswordlessAuth.generate_code(mobile, 4)
      Logger.info(code)
      case Sms.send_text_message(mobile, code) do
        :ok ->
          Logger.info("SMS Sent")
          {:noreply, socket}
        :error ->
          Logger.error("Error")
          {:noreply, socket}
      end
    else
      Logger.error("User phone in not valid!")
      {:noreply, assign(socket, step: 1)}
    end
  end

  def handle_event("validate_mobile", %{"mobile" => mobile}, socket) do
    changeset_verify =
      %User{}
      |> User.changeset_verify(%{
        "mobile" => mobile
      })
      |> Map.put(:action, :insert)

    if changeset_verify.valid? do
      if String.length(mobile) > 0 do
        {:noreply,
        socket
        |> assign(is_valid_mobile: true, mobile_empty: false)}
      else
        {:noreply,
       socket
       |> assign(is_valid_mobile: true, mobile_empty: true)}
      end
    else
      if String.length(mobile) > 0 do
        {:noreply,
        socket
        |> assign(is_valid_mobile: false, mobile_empty: false)}
      else
        {:noreply,
       socket
       |> assign(is_valid_mobile: false, mobile_empty: true)}
      end
    end
  end

  def handle_event("validate_code", %{"confirmation_code" => code}, socket) do
    matchResult = Regex.match?(~r/[0-9]{4}/, code)

    if !matchResult do
      if String.length(code) > 0 do
        {:noreply, assign(socket, is_valid_code: false, code_empty: false)}
      else
        {:noreply, assign(socket, is_valid_code: false, code_empty: true)}
      end
    else
      if String.length(code) > 0 do
        {:noreply, assign(socket, is_valid_code: true, code_empty: false)}
      else
        {:noreply, assign(socket, is_valid_code: true, code_empty: true)}
      end
    end
  end


  @impl true
  def handle_event("toggle", _value, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end
end
