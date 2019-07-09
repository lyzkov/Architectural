# GitHubActivityFeed Demo
 Architectural proposals for iOS platform

## Rationale

As you probably already know, a reactive paradigm shift is becoming inevitable on the iOS platform. Reactiveness brings exciting possibilities, generates the need for seeking new approaches and shapes architectural components of modern apps.

## Motivation

I'm a person full of crazy ideas. I can't keep them untouched so after a couple of brainstorming sessions I've started high-level frameworks up on top of RxSwift for the most common mobile development challenges. Their names simply remind me phenomenons observable at great scale across oceans.

## Libraries

🌩 [RxStorm](http://github.com/lyzkov/RxStorm) - ReSt API networking client and data pool  
🌪 [RxCyclone](http://github.com/lyzkov/RxCyclone) -  reducible machine state container  
🧭 [RxNavy](http://github.com/lyzkov/RxNavy) - state propagation through navigation segues  
🛳 [SinkEmAll](http://github.com/lyzkov/SinkEmAll) - retriable error handler inspired by the Battleship game  

Libraries are still in heavy development.  

Feel free to contribute! 👌

## Proof of concept

The application shows a list of last GitHub activities, polls it with a default time interval and filters the results. You can choose one of them and see detailed info.

## RxStorm

Networking data is fetched by lightweight API client using customizable **endpoints**, decoded from JSON to the thin model and spread further by **data pools**.  

## RxCyclone

Are you familiar with Redux Store? Each scene is powered by **reducible machine state container** called **cyclone** which is an eye of the whole module. It manages a domain model in order to achieve high-level business goals.  

You can trigger a machine tribes through predefined **inputs** driven by **sources**. Enriched inputs are translated to **events** which tells the machine how to reduce the state. State changes are propagated to the cyclone **outputs**.

## RxNavy

Navigation between scenes is done by intercepting storyboard segues and injecting necessary data to the input of destination cyclone. It conforms to Apple standards.

## SinkEmAll

Errors can be targeted by specialized protocols such as **Retriable**. You can get rid of them using highly customizable **shooters**. Each shooter can miss, hit or sink on target. That's the Battleship game.  

Please visit [homepage](http://github.com/lyzkov/SinkEmAll) for more info.

### & Enjoy! 🤓
