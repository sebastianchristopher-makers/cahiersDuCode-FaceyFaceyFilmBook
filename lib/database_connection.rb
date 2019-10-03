require 'pg'

class DatabaseConnection
  attr_reader :con

  def self.setup(dbUri)
    @con = PG.connect(dbUri.hostname, dbUri.port, nil, nil, dbUri.path[1..-1], dbUri.user, dbUri.password)
    # @con = PG.connect(dbname: db_name)
  end

  def self.query(sql, params = nil)
    @con.exec_params(sql, params)
  end
end
