function [J, grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


X = [ones(m,1), X]; % gives us 5000 * 401 %don't hardcode m
a1 = X';
a2 = sigmoid(Theta1 * a1); % 25 * 5000
a2 = [ones(1,m); a2];
a3 = sigmoid(Theta2 * a2); % 10 * 5000
anstrans = a3';
newymatrix = zeros(num_labels,m);
for i = 1:m
    newymatrix(y(i),i) = 1;
end
neglog = (-1) * log(a3);
neglogoneminus = (-1) * log(1 - a3);
J = (1/m) * sum(sum((neglog .* newymatrix) + (neglogoneminus .* (1 - newymatrix)),2),1);
% for i = 1 : m
%     ansvec = zeros(num_labels,1);
%     ansvec(y(i)) = 1; %we need to get individual vectors from the y vector because a y value represents a vector
%     neglog = (-1) * log(anstrans(i,:));
%     neglogoneminus = (-1) * log(1 - anstrans(i,:));
%     firstterm = neglog * ansvec;
%     secondterm = neglogoneminus * (1 - ansvec);
%     J = J + ((firstterm + secondterm) * (1/m));
% end
Theta1b = Theta1;
Theta1b(:,1) = [];
Theta2b = Theta2;
Theta2b(:,1) = [];
Theta1s = Theta1b .^ 2; % we need to remove first column!
Theta2s = Theta2b .^ 2;
regterm = (((sum(sum(Theta1s,1),2) + sum(sum(Theta2s,1),2))) * (lambda/(2 * m)));
J = J + regterm;

% newymatrix = zeros(num_labels,m);
% for i = 1:m
%     newymatrix(y(i),i) = 1;
% end
delta3 = a3 - newymatrix;
delta2 = ((Theta2)' * delta3) .* (a2 .* (1 - a2));
delta2(1, :) = [];
Delta1 = delta2 * a1'; % should give us 25 * 401
Delta2 = delta3 * a2'; % should give us 10 * 26 check to see if really sum again?
Theta1_grad = Delta1 * (1/m);
Theta2_grad = Delta2 * (1/m);

Theta1wozeros = Theta1(:,(2:end));
Theta2wozeros = Theta2(:,(2:end));
Theta1_grad(:,(2:end)) = Theta1_grad(:, (2:end)) + ((lambda/m) * Theta1wozeros);
Theta2_grad(:,(2:end)) = Theta2_grad(:, (2:end)) + ((lambda/m) * Theta2wozeros);

    















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end