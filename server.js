const path = require('path');
const express = require('express');
const dotenv = require('dotenv');
const colors = require('colors');
const cookieParser = require('cookie-parser');
const morgan = require('morgan');

const { checkConn } = require('./utils/dbHelper');
const apiRoutes = require('./routes/api-routes');
const testRoutes = require('./routes/test-routes');
const errorHandler = require('./middleware/error');

dotenv.config({ path: 'config/config.env' });

// Init express
const app = express();

// Check connection to db
checkConn();

// Express json parser
app.use(express.json());

// Cookie parser
app.use(cookieParser());

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Set static folder (ie. so all files can access public folder with './public/' and base directory of URI is public folder)
app.use(express.static(path.join(__dirname, 'public')));

// Mount routers
app.use('/api', apiRoutes);

// Mount dev-only test routers
if (process.env.NODE_ENV === 'development') {
  app.use('/test', testRoutes);
}

// Mount error handler
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, () => {
  console.log(
    `Server running in ${process.env.NODE_ENV} mode on port ${PORT}`.yellow.bold
  );
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Unhandled Error: ${err.message}`.bgRed);
  // Close server & exit process
  server.close(() => process.exit(1));
});
