function crowding_distance = crowding_distance_eval(critic)

number_of_objectives = size (critic , 2);

number_of_members = size (critic , 1);

crowding_distance = ones (number_of_members , 1);

if number_of_members == 1 || number_of_members == 2

    crowding_distance = inf * crowding_distance;

else

    for mem = 1 : number_of_members

        if mem == 1 || mem == number_of_members

            crowding_distance(mem) = inf;

        else
            for obj = 1 : number_of_objectives
                min_x = min(critic(:,obj));
                max_x = max(critic(:,obj));
                crowding_distance(mem) = crowding_distance(mem) + abs(critic(mem-1,obj) - critic(mem+1,obj))/(max_x - min_x);

                if isnan(crowding_distance(mem))
                    crowding_distance(mem) = 0;
                end
            end

        end

    end

end

end
