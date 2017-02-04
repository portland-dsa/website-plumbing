<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'roofingwp');

/** MySQL database username */
define('DB_USER', 'scribe');

/** MySQL database password */
define('DB_PASSWORD', '7D0RhpPXbk1WTrVM1mdWZmhDvrINjJSbRrJvq4nubonAheHlZW');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'x6gX-WUKf0jyQ-1JvZvck8AMrY2-jfc_reg');
define('SECURE_AUTH_KEY',  '1-8gRUWdDsGAcC_U7mWqhswRsvRJLDj9Qy0');
define('LOGGED_IN_KEY',    'GjVzHMI_9UFVNhFB4Wimd-alpe4x8_-6KHe');
define('NONCE_KEY',        '74T80nzThn20k4lTmc_2-mlmXaOn_q7HLDC');
define('AUTH_SALT',        '3K3aPPfD-pewmSflW_Vji81W3FrOXTw4-fR');
define('SECURE_AUTH_SALT', 'c1mCju3Z_zPhD-09dc77ASW5EnhDFkhGiSP');
define('LOGGED_IN_SALT',   'WG2j1Y_Ntw0UR-ntZ2psnSm2lXaioWSXM_m');
define('NONCE_SALT',       'a41U8If_lkf3sgNx7m9k7-nTM8kbPg0sgcB');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'roofing';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
