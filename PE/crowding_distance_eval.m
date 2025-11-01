function crowding_distance = crowding_distance_eval(critic)

number_of_objectives = size (critic , 2);

number_of_members = size (critic , 1);

crowding_distance = zeros (number_of_members , 1);

if number_of_members == 1 || number_of_members == 2

    crowding_distance = inf * crowding_distance;

else

    for mem = 1 : number_of_members

        if mem == 1 || mem == number_of_members

            crowding_distance(mem) = inf;

        else
            crowding_distance_aux = zeros(1,number_of_objectives);
            for obj = 1 : number_of_objectives
                min_x = min(critic(:,obj));
                max_x = max(critic(:,obj));
                crowding_distance_aux(1,obj) = abs(critic(mem-1,obj) - critic(mem+1,obj))/(max_x - min_x);
            end
            
            if isnan(crowding_distance_aux(1)) && isnan(crowding_distance_aux(2))
                crowding_distance(mem) = inf;
            end

        end

    end

end

end
