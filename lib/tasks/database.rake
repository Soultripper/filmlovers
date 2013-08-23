namespace :database do
  
    desc "Copy production database to local"
    task :sync => :environment do
      system 'mongodump --host juliet.mongohq.com:10028 -db app10709075 -u heroku -p1f3a4d378314afec6f72e24e06503285 -o db/backups/'
      system 'mongorestore -h localhost --drop -d filmlovers_development db/backups/app10709075/'
    end
  
    task :upload_to_staging => :environment do
      system 'mongodump --host localhost -db filmlovers_development -o db/deploys/'
      system 'mongorestore -h ethan.mongohq.com:10026 -u soultripper -porlando9 --drop -d app16665874 db/deploys/filmlovers_development'
    end

  end