# Session 6: Introduction to Julia and JuMP

Julia is a high-level, high-performance dynamic programming language for technical computing. JuMP is a library that enables us to formulate and solve mathematical programs in Julia using state-of-the-art solvers.

## Task 1: Install Julia and packages

Please download the most recent version of Julia. As of January 2023, the current stable release is v1.8.5. You can download [here](https://julialang.org/downloads/). To open Julia, navigate to your applications folder and select the Julia 1.8 icon.
You can also open it by navigating to a terminal and typing "julia". (If you have multiple versions, you must create an alias for version 1.8 to be able to open it in a terminal.)

Because Julia is a relatively new language, it is constantly under development. It is possible to have multiple Julia versions on your computer without running into issues. 

### Julia packages

We will be running a few Jupyter notebooks in this session (you were introduced to Jupyter notebooks in Session 3). IJulia basically hijacks Python's Jupyter notebook, allowing us to run Julia code in line with text, math, and visualizations. You can add IJulia by running the following commands in a Julia session.
```
julia> using Pkg
julia> Pkg.add("IJulia")
```
The package manager provides a less verbose installation alternative.
```
julia> ]
(@v1.8) pkg> add IJulia
```
You can exit the package manager by pressing delete/backspace.

While you're there, please install the following packages:
* DataFrames
* JuMP
* CSV
* Plots
* Random
* LinearAlgebra
* Printf

## Task 2: Install Gurobi

Gurobi is a commercial solver with free academic licenses. They are a pain in the booty to install, but Gurobi is quite powerful and worth the hassle! Please follow these steps to get the software onto your computer.

1. Go to [Gurobi's website](https://www.gurobi.com/) and sign up for a free account.
2. The downloads page is [here](https://www.gurobi.com/downloads/gurobi-optimizer-eula/). Accept the license agreement and download the most recent version of the Gurobi optimizer (v10.0.0). Follow the installation instructions as prompted.
3. You will need an MIT IP address for step 4. If you are off campus, you can use the [MIT VPN](https://ist.mit.edu/vpn) to connect to the network. (I would recommend only trying this after step 4 fails to work for you.)
4. After you have downloaded the optimizer software, you must obtain an Academic license. The license eventually expires, so you will have to repeat these steps every so often. (Julia will notify you when your Gurobi license is about to expire or if it has already expired--you won't be able to solve your models until it has been renewed.) Navigate [here](https://www.gurobi.com/downloads/end-user-license-agreement-academic/) and accept the conditions. Scroll to the bottom of the page and you should see something like this:
```
grbgetkey xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```
Copy the command (not this one--the one at the bottom of your page with your actual license key!) and paste it into a terminal (not a Julia REPL). Follow the default installation instructions as prompted. Now your computer is allowed to use Gurobi.
5.  Install the Gurobi wrapper in Julia. Before adding Gurobi to our Julia environment, we must point the wrapper to the location of the Gurobi Optimizer's installation. Open a Julia REPL and type the following. If you are on a Mac:
```
julia> ENV["GUROBI_HOME"] = "/Library/gurobi1000/macos_universal2/"
```
Windows:
```
julia> ENV["GUROBI_HOME"] = "C:\\Program Files\\gurobi1000\\win64\\"
```
Linux/Unix:
```
ENV["GUROBI_HOME"] = "/opt/gurobi1000/linux64/"
```
Now, regardless of operating system, run the following commands.
```
julia> using Pkg
julia> Pkg.add("Gurobi")
julia> Pkg.build("Gurobi")
```
A very common error is that the GUROBI_HOME parameter is not properly configured. Feel free to reach out with any difficulties/questions.

If you encounter many obstacles, you can also install the package `GLPK`. This optimizer is not as powerful but does not require the installation of other software.

## Preassignment

To ensure your installation environment works, please do the following. In a terminal, open Julia. Then run the following commands.
```
julia> using IJulia
julia> notebook()
```
Create a new notebook by selecting New > Julia 1.8.5. Run the following command in a cell:
```
using CSV, DataFrames, JuMP, Gurobi, LinearAlgebra, Plots, Random, Printf
```
The installation is successful if the cell does not return any errors (warnings are ok). On Canvas, submit a screenshot of the full web browser page depicting the notebook outputs and the Julia kernel in use.

## Questions?

Email haoyuew@mit.edu. 
