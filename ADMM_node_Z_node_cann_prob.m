function [evol , evol_Z] = ADMM_node_Z_node_cann_prob(X_init, U_init, Z_init, rho, alp, dim, numE, num_iter, num_iter_last_hist, ProxFPair , E1, E2, delta, target)

    X = X_init;
    Z = Z_init;
    U = U_init;

    evol = nan(num_iter,1);
    evol_Z = nan(dim,numV,num_iter_last_hist);

    
    for t = 1:num_iter

        for e = 1:numE
            i = E1(e); j = E2(e);
            [X(:,e)] =  ProxFPair( [Z(i) - U(1,e);Z(j) - U(2,e)]   ,   e   , rho*numE , E1,E2,numE,delta,target);
        end

        for i = 1:dim
            e1Neigh = find(E1 == i);
            e2Neigh = find(E2 == i);
            Z(i) = (sum(X(1,e1Neigh) + U(1,e1Neigh),2) + sum(X(2,e2Neigh) + U(2,e2Neigh),2)) / (length(e1Neigh) + length(e2Neigh));
        end


        for e = 1:numE
            i = E1(e); j = E2(e);
            U(1, e) = U(1, e) + alp*( X(1,e)  - Z(i)  );
            U(2, e) = U(2, e) + alp*( X(2,e)  - Z(j)  );
        end

        err = log(norm( Z    - target));

        evol(t) = err ;
        if (num_iter - t < num_iter_last_hist)
           evol_Z( : , : , num_iter_last_hist - (num_iter - t) ) = Z; 
        end

    end



end