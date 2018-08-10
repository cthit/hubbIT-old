( rake db:migrate && rake db:seed || (rake db:setup && rake db:seed)) && \

rails server -b 0.0.0.0
