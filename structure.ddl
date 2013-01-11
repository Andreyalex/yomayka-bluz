CREATE TABLE acl_privileges
(
  roleId INT UNSIGNED NOT NULL,
  module VARCHAR(32) NOT NULL,
  privilege VARCHAR(32) NOT NULL
);
CREATE TABLE acl_roles
(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ( id, name )
);
CREATE TABLE acl_usersToRoles
(
  userId BIGINT UNSIGNED NOT NULL,
  roleId INT UNSIGNED NOT NULL,
  PRIMARY KEY ( userId, roleId )
);
CREATE TABLE auth
(
  userId BIGINT UNSIGNED NOT NULL,
  provider VARCHAR(64) NOT NULL,
  foreignKey VARCHAR(255) NOT NULL,
  token VARCHAR(64) NOT NULL,
  tokenSecret VARCHAR(64) NOT NULL,
  tokenType CHAR(8) NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  PRIMARY KEY ( userId, provider )
);
CREATE TABLE com_content
(
  id BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  settingsId INT UNSIGNED NOT NULL,
  foreignKey INT UNSIGNED NOT NULL,
  userId BIGINT UNSIGNED NOT NULL,
  parentId BIGINT UNSIGNED,
  content LONGTEXT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  status CHAR(7) DEFAULT 'active' NOT NULL
);
CREATE TABLE com_settings
(
  id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  alias VARCHAR(32) NOT NULL,
  options LONGTEXT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  countPerPage SMALLINT DEFAULT 10 NOT NULL,
  relatedTable VARCHAR(64)
);
CREATE TABLE pages
(
  id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  title LONGTEXT NOT NULL,
  alias VARCHAR(32) NOT NULL,
  content LONGTEXT,
  keywords LONGTEXT,
  description LONGTEXT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  userId BIGINT UNSIGNED
);
CREATE TABLE users
(
  id BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  login VARCHAR(32),
  email TEXT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  status CHAR(8) DEFAULT 'disabled' NOT NULL
);
CREATE TABLE users_actions
(
  userId BIGINT UNSIGNED NOT NULL,
  code VARCHAR(255) NOT NULL,
  action CHAR(11) NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  expired TIMESTAMP DEFAULT '0000-00-00 00:00:00' NOT NULL,
  PRIMARY KEY ( userId, code )
);
ALTER TABLE acl_privileges ADD FOREIGN KEY ( roleId ) REFERENCES acl_roles ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE UNIQUE INDEX role_privilege ON acl_privileges ( roleId, module, privilege );
CREATE UNIQUE INDEX unique_name ON acl_roles ( name );
ALTER TABLE acl_usersToRoles ADD FOREIGN KEY ( roleId ) REFERENCES acl_roles ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE acl_usersToRoles ADD FOREIGN KEY ( userId ) REFERENCES users ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE auth ADD FOREIGN KEY ( userId ) REFERENCES users ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE com_content ADD FOREIGN KEY ( id ) REFERENCES com_content ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE com_content ADD FOREIGN KEY ( settingsId ) REFERENCES com_settings ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE com_content ADD FOREIGN KEY ( userId ) REFERENCES users ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE INDEX comments_target ON com_content ( settingsId, foreignKey );
CREATE INDEX FK_comments_to_users ON com_content ( userId );
CREATE UNIQUE INDEX com_aliases_unique ON com_settings ( alias );
ALTER TABLE pages ADD FOREIGN KEY ( userId ) REFERENCES users ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE UNIQUE INDEX `unique` ON pages ( alias );
CREATE INDEX FK_pages_to_users ON pages ( userId );
CREATE UNIQUE INDEX UNIQUE_login ON users ( login );
ALTER TABLE users_actions ADD FOREIGN KEY ( userId ) REFERENCES users ( id ) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE UNIQUE INDEX UNIQUE_userId_action ON users_actions ( userId, action );
