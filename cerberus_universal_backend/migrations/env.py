from __future__ import with_statement

import logging
from logging.config import fileConfig

from flask import current_app
from sqlalchemy import engine_from_config, pool, create_engine

from alembic import context

# Import the get_db_connection function from your app's config
import os
import sys
from os.path import abspath, dirname

# Add the project root to the sys.path to allow absolute imports
project_root = abspath(os.path.join(dirname(__file__), '..'))
sys.path.insert(0, project_root)

from app import create_app
from app.extensions import db

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
fileConfig(config.config_file_name)
logger = logging.getLogger('alembic.env')

# add your model's MetaData object here
# for 'autogenerate' support
# from myapp import mymodel
# target_metadata = mymodel.Base.metadata
app = create_app(os.getenv('FLASK_ENV') or 'development')
with app.app_context():
    target_metadata = db.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline():
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url, target_metadata=target_metadata, literal_binds=True
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """

    # this callback is used to prevent an auto-migration from being generated
    # when there are no changes to the schema
    # reference: http://alembic.zzzcomputing.com/en/latest/cookbook.html
    def process_revision_directives(context, revision, directives):
        if getattr(config.cmd_opts, 'autogenerate', False):
            script = directives[0]
            if script.upgrade_ops.is_empty():
                directives[:] = []
                logger.info('No changes in schema detected.')

    database_url = os.environ.get('DATABASE_URL')
    if database_url:
        # For local development, connect using the DATABASE_URL
        config.set_main_option('sqlalchemy.url', database_url)
        connectable = create_engine(database_url)
    else:
        # For production, use the Cloud SQL Python Connector
        from app.config import get_db_connection
        connectable = engine_from_config(
            config.get_section(config.config_ini_section),
            prefix='sqlalchemy.',
            poolclass=pool.NullPool,
            creator=get_db_connection
        )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            process_revision_directives=process_revision_directives,
            # Pass the configure_args if needed, but ensure they are compatible
            # **current_app.extensions['migrate'].configure_args
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()