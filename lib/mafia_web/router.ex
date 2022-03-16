defmodule MafiaWeb.Router do
  use MafiaWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MafiaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authorizedUser do
    plug(MafiaWeb.Plug.EnsureUserLoggedIn)
  end

  pipeline :superAdmin do
    plug(MafiaWeb.Plug.EnsureSuperAdmin)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MafiaWeb do
    pipe_through :browser
    live "/signin", SignInLive, :index
    get("/login/:user_id/:role/:mobile", SessionController, :login)
    get("/logout", SessionController, :logout)

  end

  scope "/", MafiaWeb do
    pipe_through [:browser, :authorizedUser]
    live "/", PageLive, :index
  end


  scope "/game/", MafiaWeb do
    pipe_through [:browser, :authorizedUser]
    live "/play/", UserContestLive.Performance, :index
    live "/leaderboard/", LeaderboardLive.Total, :index
  end

  scope "/super-admin/", MafiaWeb do
    pipe_through [:browser, :authorizedUser, :superAdmin]

    live_dashboard "/dashboard", metrics: Telemetry
    live "/session/contest/:session_id", ContestLive.Performance, :index

    live "/user", UserLive.Index, :index
    live "/user/new", UserLive.Index, :new
    live "/user/:id/edit", UserLive.Index, :edit
    live "/user/:id", UserLive.Show, :show
    live "/user/:id/show/edit", UserLive.Show, :edit

    live "/session", SessionLive.Index, :index
    live "/session/new", SessionLive.Index, :new
    live "/session/:id/edit", SessionLive.Index, :edit
    live "/session/:id", SessionLive.Show, :show
    live "/session/:id/show/edit", SessionLive.Show, :edit


    live "/question/list/:session_id", QuestionLive.Index, :index
    live "/question/new", QuestionLive.Index, :new
    live "/question/:id/edit", QuestionLive.Index, :edit
#    live "/question/:id", QuestionLive.Show, :show
    live "/question/:id/show/edit", QuestionLive.Show, :edit


    live "/answer/list/:session_id/:question_id", AnswerLive.Index, :index
    live "/answer/new", AnswerLive.Index, :new
    live "/answer/:id/edit", AnswerLive.Index, :edit
#    live "/answer/:id", AnswerLive.Show, :show
    live "/answer/:id/show/edit", AnswerLive.Show, :edit

    live "/user_vote", UserVoteLive.Index, :index
    live "/user_vote/new", UserVoteLive.Index, :new
    live "/user_vote/:id/edit", UserVoteLive.Index, :edit

    live "/user_vote/:id", UserVoteLive.Show, :show
    live "/user_vote/:id/show/edit", UserVoteLive.Show, :edit


    live "/user_total_point", UserTotalPointLive.Index, :index
    live "/user_total_point/new", UserTotalPointLive.Index, :new
    live "/user_total_point/:id/edit", UserTotalPointLive.Index, :edit

    live "/user_total_point/:id", UserTotalPointLive.Show, :show
    live "/user_total_point/:id/show/edit", UserTotalPointLive.Show, :edit




  end

  # Other scopes may use custom stacks.
  # scope "/api", MafiaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
#    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MafiaWeb.Telemetry
    end
  end
end
