require 'minitest/autorun'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/settings'
require_relative '../lib/pomoru/state'

class TimerTest < Minitest::Test
  def setup
    pomodoro = 25
    short_break = 5
    long_break = 15
    intervals = 4
    @session = Session.new(
      state: State::POMODORO,
      set: Settings.new(
        pomodoro,
        short_break,
        long_break,
        intervals
      )
    )
  end

  def test_timer_before_time_remaining_update
    # endに関しては誤差を許容することで確認
    assert_in_delta(Time.now + 1500, @session.timer.end)
    assert_equal(1500, @session.timer.remaining)
  end

  def test_update_the_remaining_time_of_pomodoro
    @session.state = 'pomodoro'
    @session.timer.time_remaining_update(@session)
    assert_in_delta(Time.now + 1500, @session.timer.end)
    assert_equal(1500, @session.timer.remaining)
  end

  def test_update_the_remaining_time_of_short_break
    @session.state = 'short break'
    @session.timer.time_remaining_update(@session)
    assert_in_delta(Time.now + 300, @session.timer.end)
    assert_equal(300, @session.timer.remaining)
  end

  def test_update_the_remaining_time_of_long_break
    @session.state = 'long break'
    @session.timer.time_remaining_update(@session)
    assert_in_delta(Time.now + 900, @session.timer.end)
    assert_equal(900, @session.timer.remaining)
  end

  def test_remaining_time_of_pomodoro
    time_remaining = "25minutes 00seconds remining on pomodoro!"
    assert_equal(time_remaining, @session.timer.time_remaining(@session))
  end

  def test_remaining_time_of_short_break
    time_remaining = "5minutes 00seconds remining on short break!"
    @session.state = 'short break'
    @session.timer.time_remaining_update(@session)
    assert_equal(time_remaining, @session.timer.time_remaining(@session))
  end

  def test_remaining_time_of_long_break
    time_remaining = "15minutes 00seconds remining on long break!"
    @session.state = 'long break'
    @session.timer.time_remaining_update(@session)
    assert_equal(time_remaining, @session.timer.time_remaining(@session))
  end
end
