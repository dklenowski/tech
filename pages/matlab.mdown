Categories: programming
Tags: matlab
	  maths

# Pro Tips

## Re-running programs

When you re-run a matlab file that has changed you first need to issue a `clear`.

e.g. if we want to run `a.m`

	run('a.m')

If you need to re-run `a.m` (e.g. if you have updated a variable), you must first issue a `clear`

	clear('a.m')


and then run `a.m`

	run('a.m')

## Plotting Axes on 3D Graph

	figure;
	hold on;
	
	% labels
	grid on;
	xlabel('x');
	ylabel('y');
	zlabel('z');
	axis([-sz sz -sz sz -sz sz]);
	xlim([-sz sz]);
	ylim([-sz sz]);
	zlim([-sz sz]);
	plot3(lims(1:2),[0 0],[0 0], 'LineWidth', 1.5, 'Color', 'blue') % x axis
	plot3([0 0],lims(3:4),[0 0], 'LineWidth', 1.5, 'Color', 'green') % y axis
	plot3([0 0],[0 0],lims(5:6), 'LineWidth', 1.5, 'Color', 'red') % z axis


# Matrix

## Print

	display(mat)

## Transpose

	y = x'

## Select columns

### To select the first column (where `m` is the matrix you want to select from)

	e=m(:,1)


## Adding a row to a matrix

	% a = (4,2) c=(4,3)
	c=[a.neg_examples_nobias ones(4,1)]

# File Manipulation

## Import

	a=importdata('/myroot/coursera/neural-networks/wk3/Assignment1/Datasets/dataset1.mat')
	x = a(:,1);
	y = a(:,2);
	z = a(:,3);

	plot3(x,y,z, 'LineWidth', 2.0, 'Color', 'black');	

## Iterate through directory


	paths = dir(fullfile('/tmp/braintrace', '*.txt'));
	for path = paths'
    	a=importdata(fullfile('/tmp/braintrace',path.name));
   		plot3(a(:,1), a(:,2), a(:,3));
	end


# Vectors

## Eigenvectors

	[e_vec,e_val]=eig(m)


Note, the eigenvectors are the columns of `e_vec`.


# Miscellaneous

## Clearing command window

To clear the command window, use

	clc

## Clearing variables

To clear variables, use

	clear

# Troubleshooting

## Display a variable

	display(X)
	fprintf('%s will be %d this year.\n',name,age);

