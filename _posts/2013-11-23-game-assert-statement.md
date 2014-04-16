---
layout: default
date: 2013-11-23 15:59:00
parent-url: /
parent: owlwood
title: Game assert statement
---
I use statements like this to check conditions for some routine to work:  

{% highlight c++ %}
if(someone.inventory.empty()) {  
	message(format("{0} inventory is empty.", someone.name));  
	return;  
}
{% endhighlight %}

That is, if someone's inventory is empty, the whole routine cannot be executed, so we skip it. But they're just taking place (each one 4 lines at least) and are all pretty much following the same pattern, so they could be replaced with one function call like this:   

{% highlight c++ %}
game_assert(  
	!someone.inventory.empty(),  
	format("{0} inventory is empty.", someone.name)  
);
{% endhighlight %}

Return statement could not be used there, but exeception throwing works pretty much the same way: it breaks execution flow and correctly destroys all local variables. And it could carry data like message text, which can be displayed when exception is catched. So full `game_assert` function looks like this: 
    
{% highlight c++ %}    
void game_assert(bool condition, const std::string & message)  
{  
	if(!condition) {  
		throw Message(message);  
	}  
}
{% endhighlight %}

Disadvantage of this way it that one really need to enclose all code that calls such functions in try..catch block.

