namespace :db do
  namespace :seed do
    desc 'Run seeds based on the file timestamps in `db/seeds/*.rb`'
    task all: :environment do
      ActiveRecord::Base.connection_pool.with_connection do
        last_versions = ActiveRecord::Base.connection.execute('SELECT version FROM schema_seedings ORDER BY created_at ASC').values.flatten

        return if last_versions.nil?

        Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |filename|
          task_name = File.basename(filename, '.rb')
          version = task_name.split('_').first
          next if last_versions.include?(version)

          _, *name_parts = task_name.split('_')
          constant_name = name_parts.map(&:capitalize).join
          puts '========================================================================='
          puts "== Seed Version: #{version} - Running Seed: #{constant_name} =="
          puts '========================================================================='
          start_time = Time.now

          load(filename) if File.exist?(filename)
          file_content = File.read(filename)

          Object.const_get(constant_name.gsub("#{version}", '')).try(:run) if file_content =~ /def\s+self.run/

          sql = <<-SQL
            INSERT INTO schema_seedings (version, created_at, updated_at)
            VALUES ($1, $2, $3)
          SQL

          ActiveRecord::Base.connection.exec_query(sql, 'SQL', [
                                                     version,
                                                     Time.now,
                                                     Time.now
                                                   ])

          puts '========================================================================='
          puts "== Seed Version: #{version} - Completed in: #{format('%.4fs', Time.now - start_time)} =="
          puts '========================================================================='
        end
      end
    end

    desc 'Run only the most recent seed file based on the timestamp in `db/seeds/*.rb`'
    task last: :environment do
      seed_files = Dir[Rails.root.join('db', 'seeds', '*.rb')]
      filename = seed_files.last
      task_name = File.basename(filename, '.rb')
      version = task_name.split('_').first

      _, *name_parts = task_name.split('_')
      constant_name = name_parts.map(&:capitalize).join
      puts '========================================================================='
      puts "== Seed Version: #{version} - Running Seed: #{constant_name} =="
      puts '========================================================================='
      start_time = Time.now

      load(filename) if File.exist?(filename)

      Object.const_get(constant_name).try(:run)
      puts '========================================================================='
      puts "== Seed Version: #{version} - Completed in: #{format('%.4fs', Time.now - start_time)} =="
      puts '========================================================================='
    end

    desc 'Rollback only the most recent seed file based on the timestamp in `db/seeds/*.rb`'
    task rollback: :environment do
      ActiveRecord::Base.connection_pool.with_connection do
        last_version = ActiveRecord::Base.connection.execute('SELECT version FROM schema_seedings ORDER BY created_at DESC LIMIT 1').first&.dig('version')

        seed_files = Dir[Rails.root.join('db', 'seeds', '*.rb')]
        filename = seed_files.find { |file| file.include?(last_version) }

        if filename.nil?
          puts "No seed file found for version #{last_version}."
          next
        end

        task_name = File.basename(filename, '.rb')
        _, *name_parts = task_name.split('_')
        constant_name = name_parts.map(&:capitalize).join

        puts '========================================================================='
        puts "== Seed Version: #{last_version} - Rollback Seed: #{constant_name} =="
        puts '========================================================================='
        start_time = Time.now

        load(filename) if File.exist?(filename)
        puts '========================================================================='
        if Object.const_defined?(constant_name) && Object.const_get(constant_name).respond_to?(:rollback)
          Object.const_get(constant_name).rollback
          puts "== Seed Version: #{last_version} - Rollback Completed in: #{format('%.4fs', Time.now - start_time)} =="
          ActiveRecord::Base.connection.execute("DELETE FROM schema_seedings WHERE version = '#{last_version}'")
          puts '========================================================================='
        else
          puts "== Seed Version: #{last_version} - Rollback method not defined for #{constant_name} =="
        end
      end
    end

    desc 'Run a specific seed file by name'
    task :run_specific, [:seed_name] => :environment do |_t, args|
      seed_name = args[:seed_name]
      raise 'Seed name is required. Use: rails db:seed:run_specific[seed_name]' if seed_name.nil?

      seed_files = Dir[Rails.root.join('db', 'seeds', '*.rb')]
      filename = seed_files.find { |file| File.basename(file, '.rb').include?(seed_name) }

      if filename.nil?
        puts "No seed file found with the name #{seed_name}."
        next
      end

      task_name = File.basename(filename, '.rb')
      version = task_name.split('_').first

      _, *name_parts = task_name.split('_')
      constant_name = name_parts.map(&:capitalize).join

      puts '========================================================================='
      puts "== Seed Version: #{version} - Running Seed: #{constant_name} =="
      puts '========================================================================='
      start_time = Time.now

      load(filename) if File.exist?(filename)

      if Object.const_defined?(constant_name) && Object.const_get(constant_name).respond_to?(:run)
        Object.const_get(constant_name).run
      else
        puts "== Seed Version: #{version} - Run method not defined for #{constant_name} =="
      end

      puts '========================================================================='
      puts "== Seed Version: #{version} - Completed in: #{format('%.4fs', Time.now - start_time)} =="
      puts '========================================================================='
    end
  end
end
