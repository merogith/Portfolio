-- SQLite. UTC timestamps; snapshot = 2026-01-15 00:00:00.
-- The compact fixture expands to one user per row in users and events.
-- Only mature signups enter the denominator. Stages must happen in order,
-- at or after the prior stage and strictly before signup + 7 days.
WITH mature AS (
  SELECT user_id, signup_at FROM users
  WHERE signup_at <= datetime('2026-01-15 00:00:00', '-7 days')
), profile AS (
  SELECT u.user_id, u.signup_at, MIN(e.event_at) AS profile_at
  FROM mature u LEFT JOIN events e ON e.user_id = u.user_id
    AND e.event = 'profile' AND e.event_at >= u.signup_at
    AND e.event_at < datetime(u.signup_at, '+7 days')
  GROUP BY u.user_id, u.signup_at
), booking AS (
  SELECT p.*, MIN(e.event_at) AS booking_at
  FROM profile p LEFT JOIN events e ON e.user_id = p.user_id
    AND e.event = 'booking' AND e.event_at >= p.profile_at
    AND e.event_at < datetime(p.signup_at, '+7 days')
  GROUP BY p.user_id, p.signup_at, p.profile_at
), completion AS (
  SELECT b.*, MIN(e.event_at) AS completed_at
  FROM booking b LEFT JOIN events e ON e.user_id = b.user_id
    AND e.event = 'completion' AND e.event_at >= b.booking_at
    AND e.event_at < datetime(b.signup_at, '+7 days')
  GROUP BY b.user_id, b.signup_at, b.profile_at, b.booking_at
)
SELECT COUNT(*) AS signed_up, COUNT(profile_at) AS completed_profile,
       COUNT(booking_at) AS booked_consultation, COUNT(completed_at) AS completed_consultation
FROM completion;
