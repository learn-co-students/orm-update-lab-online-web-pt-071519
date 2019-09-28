require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade, :id
    
  def initialize(id=nil, name, grade)
    @id = id[0]
    @name = name[1]
    @grade = grade[2]
    # initialize the instance variables for your table.
    # add attr_ above 
    # set id argument to nil and let save assign record id
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
    # accepts an argument for one row
    # sets variables for each db element
    # instantiates a new class instance that takes in each db element as an argument
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    # takes in arguments from attr_s 
    # assigns a new instance of a student to a variable
    # and save it to the db without an id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
    # creates a new table with a sql heredoc
  end

  def self.drop_table
    sql = "DROP TABLE IF TABLE EXISTS students"
    DB[:conn].execute(sql)
    # checks for and drops your table by name if it exists
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students(name, grade)
        values (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      # Checks for a duplicate record
      # Uses a SQL INSERT and inserts a new row into the database using the attributes (self.argument)
      # Assigns the id attribute of the object once the row has been inserted into the database.

    end
  end

  def update
    sql = <<-SQL
        UPDATE student
        SET name = ?, grade = ?
        WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    # Updates the database row mapped to the given Student instance.
  end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
