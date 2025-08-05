
"""Add currency to donations table

Revision ID: 20250804235018
Revises: 
Create Date: 2025-08-04 23:50:18.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '20250804235018'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('donations', sa.Column('currency', sa.String(length=10), nullable=False, server_default='usd'))


def downgrade():
    op.drop_column('donations', 'currency')

