# Preassignment 8

In this session, we will be working with computing clusters. To complete the in-class exercises and homework, you will need access to a computing cluster, either the Engaging cluster or SuperCloud. Please select one of the three options below for access and follow the instructions in the corresponding section.
- **Option 1: Engaging Open On Demand** - The Engaging cluster has resources open to all MIT students. Anyone with a valid Kerberos account can login where upon an account will be made if one does not exist. *This is the quickest and lowest effort option.* Perfect for those who don't have an immediate need for big computing resources but want to try it out. 
- **Option 2: Engaging with Sloan Resources** - Engaging also has compute resources dedicated to Sloan which are helpful if you're planning to use the cluster for research projects. To gain access to these resources, you need to be affiliated with Sloan or the ORC and must provide the name of a Sloan faculty sponsor for your account (typically your advisor). 
- **Option 3: SuperCloud** - The Supercloud cluster is a collaboration with MIT Lincoln Laboratory and is open to everyone on campus. It has a collaboration feature which lets you create shared files that all desired collaborators can access.  It also requires an access request and an email from your advisor confirming you plan to use SuperCloud for your work/research. 

All of these options will work for our class!

## Select one of the following option to use in class and complete the pre-assignment:

### Option 1: Engaging Open On Demand 
Login to [https://engaging-ood.mit.edu](https://engaging-ood.mit.edu). Click Clusters, then Engaging Shell Access. This should open a browser window with a terminal that says either `[yourusername@eofe7 ~]$` or `[yourusername@eofe8 ~]$`. This is one of the login nodes of the Engaging cluster. You're in!

Once you've logged into Engaging, run the following commands *in this order* in the terminal (don't worry if you don't understand what we're doing here - we'll discuss during the session):

1. ```srun --pty --partition=sched_any_quicktest --cpus-per-task=1 --mem=2G bash```  (Note: this may take a few minutes depending on how busy the cluster is)
2. ```module load julia/1.7.3```
3. ```module load gurobi/8.1.1```
4. ```julia``` (At this point, a Julia session will open)
5. Enter the following commands to Julia to load the packages we need, then exit the Julia window (this may take a while): 

```julia
julia> using Pkg

julia> Pkg.add("DataFrames")

julia> Pkg.add("CSV")

julia> Pkg.add("JuMP")

julia> Pkg.add("Gurobi")

julia> Pkg.add("Plots")

julia> using DataFrames, CSV, JuMP, Gurobi

julia> exit()
```
5. Type ```exit```. This should bring you back to the login node, so your terminal will again say `[yourusername@eofe7 ~]$` or `[yourusername@eofe8 ~]$`. 
5. Type ```exit``` again. This will end the cluster session. 
6. **Take a screenshot of your terminal window and commands**.
7. You can then close out of the Engaging shell browser window. 

### Option 2: Engaging with Sloan Resources
Request an account [here](https://mitsloan.service-now.com/sloanservice?id=sc_cat_item&sys_id=cdc71c54db10401479297deaae9619ba). This may take a few days.

Once your account has been created, you can login to Engaging. We'll login in with SSH (SecureSHell). 

If you're using **Mac/linux**, type `ssh <kerberos_user_name>@eosloan.mit.edu` into the terminal and enter your password. 

If you're using **Windows**, there are many options for access. The simplest is to open Git Bash (see pre-assignment 1),  type `ssh <kerberos_user_name>@eosloan.mit.edu` into the terminal and enter your password. If you're more comfortable with graphical interfaces than command line, you can also download [MobaXterm](https://engaging-web.mit.edu/eofe-wiki/logging_in/ssh/windows/), as recommended by the Engaging Admin. In class, we'll use Git Bash for consistency, but I'll mention MobaXterm as well!  

Once you've logged into Engaging, check to ensure you can run the following commands (don't worry if you don't understand what we're doing here - we'll discuss during the session):

1. ```srun --pty --partition=sched_any_quicktest --cpus-per-task=1 --mem=2G bash```  (Note: it may take a while before you are allocated resources depending on how busy the cluster is)
2. Once you have been allocated resources, your terminal will display `[username@node029 ~]$` or some other node number. We can then proceed to load some software modules.
3. ```module load julia/1.7.3```
4. ```module load gurobi/8.1.1```
5. ```julia``` (At this point, a Julia session will open)
6. Enter the following commands to Julia to load the packages we need, then exit the Julia window (this may take a while): 

```julia
julia> using Pkg

julia> Pkg.add("DataFrames")

julia> Pkg.add("CSV")

julia> Pkg.add("JuMP")

julia> Pkg.add("Gurobi")

julia> Pkg.add("Plots")

julia> using DataFrames, CSV, JuMP, Gurobi

julia> exit()
```
5. Enter ```exit```. This should bring you back to the login node. 
5. Type ```exit``` again. This will end the cluster session. 
6. **Take a screenshot of your terminal window and commands**.
7. You can then close out of your terminal window. 

### Option 3: SuperCloud
Request an account [here](https://supercloud.mit.edu/requesting-account). As the instructions mention, email your advisor and request that they send an email to [supercloud@mit.edu](mailto:supercloud@mit.edu?subject=Confirming%20Supercloud%20Account) confirming that you plan to use your cluster account for your research. This may take a few days.

Once your account has been created, you can login to SuperCloud using the username they emailed to you. We'll login in with SSH (SecureSHell). Follow the instructions [here](https://supercloud.mit.edu/requesting-account#ssh-keys) to set up your SSH key or simply use the same SSH key you used for Github. Add the SSH key to your account, instructions [here](https://supercloud.mit.edu/requesting-account#adding-keys). 

Then, we can use SSH to login to SuperCloud!

If you're using **Mac/linux**, type `ssh <kerberos_user_name>@txe1-login.mit.edu` into the terminal and enter your password. 

If you're using **Windows**, there are many options for access. The simplest is to open Git Bash (see pre-assignment 1),  type `ssh <kerberos_user_name>@txe1-login.mit.edu` into the terminal and enter your password. 

Once you've logged into SuperCloud, check to ensure you can run the following commands:

1. ```module load julia/1.7.3```
2. ```module load gurobi/gurobi-811```
3. ```julia``` (At this point, a Julia session will open)
4. Enter the following commands to Julia to load the packages we need, then exit the Julia window (this may some time): 

```julia
julia> using Pkg

julia> Pkg.add("DataFrames")

julia> Pkg.add("CSV")

julia> Pkg.add("JuMP")

julia> Pkg.add("Gurobi")

julia> Pkg.add("Plots")

julia> using DataFrames, CSV, JuMP, Gurobi

julia> exit()
```
5. Type ```exit```. This will end the cluster session. 
4. **Take a screenshot of your terminal window and commands**.
5. You can then close out of your terminal window. 

## Canvas Submission

**Submit the screenshot of your cluster terminal on Canvas.** If your Sloan Engaging or SuperCloud account hasn't been created by the time of the class, please follow the instructors for Option 1 to use Engaging OnDemand, which you should be able to access right away. 

## Questions? 
Email Alex at aschmid@mit.edu.
