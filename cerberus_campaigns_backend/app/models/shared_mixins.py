from sqlalchemy.sql import func
from ..extensions import db

class TimestampMixin:
    """
    Mixin for adding created_at and updated_at timestamps to models.
    Uses server-side defaults for created_at and a database trigger
    or SQLAlchemy event for updated_at.
    """
    created_at = db.Column(db.DateTime(timezone=True), server_default=func.now())
    updated_at = db.Column(db.DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

# Note: `onupdate=func.now()` works for many databases (like PostgreSQL and MySQL)
# to update the timestamp automatically at the database level.
# If using a database that doesn't support this directly (e.g., older SQLite versions
# without triggers defined as in the schema.sql), you might need SQLAlchemy events
# or application-level logic to update `updated_at`.

# The `database_schema.sql` already defines a trigger `trigger_set_timestamp`
# for PostgreSQL. If using that, the `onupdate=func.now()` here is somewhat redundant
# but harmless as it aligns with the DB behavior. For other DBs, `onupdate` is useful.
# If we rely *solely* on the PostgreSQL trigger, we could omit `onupdate=func.now()`
# and just have `updated_at = db.Column(db.DateTime(timezone=True), server_default=func.now())`.
# However, including it makes the model more portable if the backend DB changes or if
# the trigger isn't present.

# Example of using SQLAlchemy events if DB-level onupdate is not available/desired:
# from sqlalchemy import event
# from YourApp.extensions import db # Assuming db is your SQLAlchemy instance
#
# class TimestampMixin:
#     created_at = db.Column(db.DateTime(timezone=True), server_default=func.now())
#     updated_at = db.Column(db.DateTime(timezone=True), default=func.now())

# @event.listens_for(YourModelClass, 'before_update', propagate=True)
# def timestamp_before_update(mapper, connection, target):
#     target.updated_at = func.now()
#
# This would require applying the event listener to each model class that uses the mixin.
# For simplicity and common DB support, `onupdate=func.now()` is often sufficient.
