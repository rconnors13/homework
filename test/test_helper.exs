Application.ensure_all_started(:hound)
ExUnit.start()
ExUnit.configure exclude: [dont_run: false]
