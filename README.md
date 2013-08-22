# Simple Database

[![Build Status](https://travis-ci.org/pseudomuto/ruby_simple_db.png)](https://travis-ci.org/pseudomuto/ruby_simple_db)

This was a programming challenge I found online and thought I'd play around with. I've copied this origin problem here in the README in case you want to try it yourself (without using this code of course).

## Original Problem

Your task is create a very simple in-memory database, which has a very limited command set. Please code your solution in one of the following languages: Python, PHP, JavaScript, Ruby, Perl, Java, C++ or C. This problem should take you anywhere from 30 to 90 minutes. All of the commands are going to be fed to you one line at a time via stdin, and your job is to process the commands and to perform whatever operation the command dictates.

### Commands you need to handle

* SET [name]&nbsp;[value]: Set a variable [name] to the value [value]. Neither variable names nor values will ever contain spaces.
* GET [name]: Print out the value stored under the variable [name]. Print NULL if that variable name hasn't been set.
* UNSET [name]: Unset the variable [name]
* NUMEQUALTO [value]: Return the number of variables equal to [value]. If no values are equal, this should output 0.
* END: Exit the program

So here is a sample input:

	SET a 10
	GET a
	UNSET a
	GET a
	END

And its corresponding output:

	10
	NULL


And another one:

	SET a 10
	SET b 10
	NUMEQUALTO 10
	NUMEQUALTO 20
	UNSET a
	NUMEQUALTO 10
	SET b 30
	NUMEQUALTO 10
	END

And its corresponding output:

	2
	0
	1
	0

Now, as I said this was a database, and because of that we want to add in a few transactional features to help us maintain data integrity. So there are 3 additional commands you will need to support:

BEGIN: Open a transactional block
ROLLBACK: Rollback all of the commands from the most recent transactional block. If no transactional block is open, print out NO TRANSACTION
COMMIT: Permanently store all of the operations from any presently open transactional blocks. If no transactional block is open, print out NO TRANSACTION
Our database supports nested transactional blocks as you can tell by the above commands. Remember, ROLLBACK only rolls back the most recent transaction block, while COMMIT closes all open transactional blocks. Any command issued outside of a transactional block commits automatically. The most commonly used commands are GET, SET, UNSET and NUMEQUALTO, and each of these commands should be faster than O(N) expected worst case, where N is the number of total variables stored in the database. Hint: this means that, for example, if your database had 100 items in it, your solution should be able to perform the GET, SET, UNSET and NUMEQUALTO operations without scanning all 100 items. 

Typically, we will already have committed a lot of data when we begin a new transaction, but the transaction will only modify a few values. So, your solution should be efficient about how much memory is allocated for new transactions, i.e., it is bad if beginning a transaction nearly doubles your program's memory usage. Here are some sample inputs and expected outputs using these commands:

Input:

	BEGIN
	SET a 10
	GET a
	BEGIN
	SET a 20
	GET a
	ROLLBACK
	GET a
	ROLLBACK
	GET a
	END

Output:

	10
	20
	10
	NULL


Input:

	BEGIN
	SET a 30
	BEGIN
	SET a 40
	COMMIT
	GET a
	ROLLBACK
	END

Output:

	40
	NO TRANSACTION


Input:

	SET a 50
	BEGIN
	GET a
	SET a 60
	BEGIN
	UNSET a
	GET a
	ROLLBACK
	GET a
	COMMIT
	GET a
	END

Output:

	50
	NULL
	60
	60


Input:

	SET a 10
	BEGIN
	NUMEQUALTO 10
	BEGIN
	UNSET a
	NUMEQUALTO 10
	ROLLBACK
	NUMEQUALTO 10
	END

Output:

	1
	0
	1

## Usage

* fork/clone
* bundle install
* `bundle exec guard` for tests
* `ruby bin/simple_db.rb` to use the app

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
