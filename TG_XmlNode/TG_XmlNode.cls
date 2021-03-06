/*
Copyright (c) 2010 tgerm.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
 
/* 
 *  Element  class definition
 
	This following class implements a small portion of the wc3 xml dom model.  
	Generally useful for simple XML return objects. 
	
	for a properties and methods complete list see: 
	http://www.w3schools.com/dom/dom_node.asp
	
	For simplicity, Nodes are the same as Elements in this class.
	Nodes have text directly in them, rather than a seperate text node child
	The following describes the implemented portion, some w3c properties are now methods.	

	Property			Description
	========    		============	
	childNodes				Returns a NodeList of child nodes for a node	
	firstChild				Returns the first child of a node	
	lastChild				Returns the last child of a node	
	namespaceURI			Returns the namespace URI of a node	
	nextSibling				Returns the node immediately following a node	
	nodeName				Returns the name of a node, depending on its type	
	nodeType				Returns the type of a node	
	nodeValue				Sets or returns the value of a node, depending on its type	
	parentNode				Returns the parent node of a node
	prefix					Sets or returns the namespace prefix of a node	
	previousSibling			Returns the node immediately before a node	
	textContent				Sets or returns the textual content of a node and its descendants	
	xml						Returns the XML of a node and its descendants. 


	Methods
	-------

	Method							Description
	======							===========
	hasAttributes()					Returns true if a node has any attributes, otherwise it returns false	
	hasChildNodes()					Returns true if a node has any child nodes, otherwise it returns false	
	isDefaultNamespace(URI)			Returns whether the specified namespaceURI is the default	 	
	lookupNamespaceURI()			Returns the namespace URI matching a specified prefix	
	lookupPrefix()					Returns the prefix matching a specified namespace URI	
	removeChild()					Removes a child node	
	cloneNode(boolean deep)			Clones a node	
	
	
	TODO:
	=====
	Implement and add testMethods for each of the following, As spring 10 API doesn't have direct methods for doing so many of the
	following methods might involve recursions etc to clone, compare and append/replace/insert child
	appendChild()					Adds a new child node to the end of the list of children of a node	
	compareDocumentPosition()		Compares the document position of two nodes	
	getUserData(key)				Returns the object associated to a key on a this node. The object must first have been set to this node by calling setUserData with the same key
	isEqualNode()					Checks if two nodes are equal	
	isSameNode()					Checks if two nodes are the same node	
		
	COSTLY TO ADD APIs for LATER CONSIDERATION
	===========================================
	insertBefore()					Inserts a new child node before an existing child node. TGERM: We can implement this but there is no such API from Spring 10 classes and doing this on
									own might eat a lot of script statements.
	replaceChild()					Replaces a child node. TGERM: we can't replace the same child again, because of the same reason, we might need to eat a lot of script statements to do so.		
	
	WILL NOT BE INCLUDED IN API
	============================
	Following methods are there in w3c DOM Node but we will not implement them
	baseURI							Returns the absolute base URI of a node	
	localName						Returns the local part of the name of a node
	isSupported(feature,version)	Returns whether a specified feature is supported on a node
	normalize()						Puts all text nodes underneath a node (including attributes) into a "normal" form where only structure (e.g., elements, comments, processing instructions, CDATA sections, and entity references) separates Text nodes, i.e., there are neither adjacent Text nodes nor empty Text nodes	
	setUserData(key,data,handler)	Associates an object to a key on a node
	text							Returns the text of a node and its descendants.
	ownerDocument					Returns the root element (document object) for a node. TGERM: we are giving Root instead
	getFeature(feature,version)		Returns a DOM object which implements the specialized APIs of the specified feature and version	 
									
 */
public virtual class TG_XmlNode {
	public static final Integer MAX_ELEMENTS_TILL_LEAF = -1; 
	
	/*
	   The Native Dom.XMLNode its made available if one wants to use the Spring 10 node at some point	
 	*/
	public Dom.XmlNode xmlNode {get;private set;}
	
	public TG_XmlNode(Dom.XmlNode node) {
		xmlNode = node;
	}
	
	/**
		Returns the name of a node	
	*/
	public String nodeName {
		get{
			return xmlNode.getName();
		} protected set;}
	
	/**
		Sets or returns the value of a node
	*/
	public String nodeValue {
		get{ 
			return xmlNode.getText();
		} 
		set{
			Dom.XmlNode[] existing  = xmlNode.getChildren();
			if (existing != null && !existing.isEmpty()) 
				for (Dom.XmlNode n : existing) 
					if (n.getNodeType() == dom.XmlNodeType.TEXT) xmlNode.removeChild(n); 
			xmlNode.addTextNode(value);	
		}
	}
	
	/*
		Returns a NodeList of child nodes for a node
	*/	
	public List<TG_XmlNode> childNodes {
		get {
			Dom.XmlNode[] kidNodes = this.xmlNode.getChildren();
			childNodes = new List<TG_XmlNode>();
			if (kidNodes != null && !kidNodes.isEmpty()) {
				for (Dom.XmlNode kid: kidNodes )
					childNodes.add(new TG_XmlNode(kid));	
			} 
			return childNodes;
		} protected set;
	}	
	
	/*
		The firstChild property returns the first child node of this Dom Element.
	*/
	public TG_XmlNode firstChild {
		get {
			Dom.XmlNode[] kids  = this.xmlNode.getChildren();
			return kids != null && !kids.isEmpty() ? new TG_XmlNode(kids[0]) : null;
		} protected set;
	}
	
	/*
		The lastChild property returns the last child node of this Dom Element.
	*/
	public TG_XmlNode lastChild {
		get {
			Dom.XmlNode[] kids  = this.xmlNode.getChildren();
			return kids != null && !kids.isEmpty() ? new TG_XmlNode(kids[kids.size() - 1]) : null;
		} protected set;
	}
	
	/*
		The namespaceURI property sets or returns the namespace URI of this element.
	*/
	public String namespaceURI {
		get {
			return xmlNode.getNamespace();
		} 
		set {
			xmlNode.setNamespace('', value);
		}
	}
	
	/*
		Returns the node immediately following a node	
	*/
	public TG_XmlNode nextSibling {
		get {
			TG_XmlNode next = null;
			Dom.XmlNode parent = xmlNode.getParent();
			if (parent == null) return next;
			Dom.XmlNode[] kids = parent.getChildren();
			Integer thisNodeIdx = -1;
			if (kids != null && !kids.isEmpty()) {
				for (Integer idx = 0; idx < kids.size() ; idx++) {
					Dom.XmlNode kid = kids[idx];
					if (kid == this.xmlNode) {
						thisNodeIdx = idx;
						break;	
					}
				}
				if (thisNodeIdx >= 0 && thisNodeIdx < (kids.size() -1)) {
					next = new TG_XmlNode(kids [thisNodeIdx + 1]);		
				}	
			}
			return next;	
		} protected set;
	}
	
	/*
		Returns the root element for a node
	*/
	public TG_XmlNode root {
		get {
			Dom.XmlNode ret = this.xmlNode; 
			while( ret.getParent() != null) { ret = ret.getParent(); } 		
			// if one is at root return this otherwise create a new root element	
			return ret == this.xmlNode ? this : new TG_XmlNode(ret) ;	
		} 
	} 

	/* 
		Returns the parent node of a node
	*/
	public TG_XmlNode parentNode {
		get{
			Dom.XmlNode p = xmlNode.getParent();
			return p != null ? new TG_XmlNode(p): null;
		} 
		protected set;
	}
	
	/*
		Returns the namespace prefix of a node
		LIMITATION: We are not allowing to change the prefix
	*/	
	public String prefix {
		get {
			return xmlNode.getNamespace() != null ? xmlNode.getPrefixFor(xmlNode.getNamespace()) : null;
		} private set;
	}
	
	/*
		Returns the node immediately before a node
	*/	
	public TG_XmlNode previousSibling	{
		get {
			TG_XmlNode prev = null;
			Dom.XmlNode parent = xmlNode.getParent();
			if (parent == null) return prev;
			Dom.XmlNode[] kids = parent.getChildren();
			Integer thisNodeIdx = -1;
			if (kids != null && !kids.isEmpty()) {
				Integer idx = kids.size() - 1;
				for (; idx > -1; idx--) {
					Dom.XmlNode kid = kids[idx];
					if (kid == this.xmlNode) {
						thisNodeIdx = idx;
						break;	
					}
				}
				if (thisNodeIdx > 0) {
					prev = new TG_XmlNode(kids [thisNodeIdx - 1]);		
				}	
			}
			
			return prev;	
		} protected set;
	}

	
	/*
		Returns the Node type out of all 12 nodetypes only 3 are supported
		• COMMENT
		• ELEMENT
		• TEXT
		
		ZERO (0) is returned on unsupported type
	*/
	public Integer nodeType {
		get{
			if (nodeType == null) {
				dom.XmlNodeType nt = xmlNode.getNodeType();
				if (nt == dom.XmlNodeType.ELEMENT) 
					nodeType = 1;
				else if (nt == dom.XmlNodeType.TEXT) 
					nodeType = 3; 	
				else if (nt == dom.XmlNodeType.COMMENT) 
					nodeType = 8;
				else
					nodeType = 0;
			}	
			return nodeType;  
		} protected set;
	}
	
	/*
		The textContent property sets or returns the textual content of a node and its descendants.
		On setting, any child nodes are removed and replaced by a single Text node containing the string this property is set to.
	*/
	public String textContent{
		get {
			return TG_XmlUtils.getTextContents(xmlNode);
		}
		set {
			Dom.XmlNode[] existing  = xmlNode.getChildren();
			if (existing != null && !existing.isEmpty()) 
				for (Dom.XmlNode n : existing) 
					xmlNode.removeChild(n); 
			xmlNode.addTextNode(value);	
		}
	}	
		
	public Map<String,String> attributes {
		get {
 			if (attributes != null) return attributes;
			attributes = new Map<String, String>();
			Integer attribCount = xmlNode.getAttributeCount();
			for (Integer idx = 0 ; idx < attribCount ; idx ++) {
				String aNs = xmlNode.getAttributeKeyNsAt(idx);
				String aKey = xmlNode.getAttributeKeyAt(idx);
				String aVal = xmlNode.getAttributeValue(aKey, aNs);
				attributes.put(aKey, aVal);
			}
			return attributes;
		} public set;
	}
	
	/*
		Returns attribute value for the attribute name
	*/	
	public virtual String getAttribute(string name) {
		return attributes.get(name); 
	}
		
	/**
		Returns all the Elements matching the specified tag name.
	*/
	public virtual List<TG_XmlNode> getElementsByTagName(String nam) {
		TG_XmlUtils.NodeNameInfo nameInfo = TG_XmlUtils.getNamespaceFromNodeName(nam, this.xmlNode);
		List<TG_XmlNode> ret = new List<TG_XmlNode>();
		loadChildElementsForTagName(this.xmlNode, nameInfo.localName, nameInfo.namespaceURI, ret);
		return ret;
	}

	/**
		Returns all the Elements matching the specified tag name.
	*/
	public virtual List<TG_XmlNode> getElementsByTagNameNS (String namespaceURI, String nam) {
		List<TG_XmlNode> ret = new List<TG_XmlNode>();
		loadChildElementsForTagName(this.xmlNode, nam, namespaceURI, ret);
		return ret;
	}

	/*
		Returns single Element matching the specified tag name.
	*/	 
	public virtual TG_XmlNode getElementByTagName(String nam) {
		TG_XmlUtils.NodeNameInfo nameInfo = TG_XmlUtils.getNamespaceFromNodeName(nam, this.xmlNode);
		return loadChildElementForTagName(this.xmlNode, nameInfo.localName, nameInfo.namespaceURI);
	}
	
	
	/*
		Returns the namespace URI matching a specified prefix
	*/ 
	public virtual String lookupNamespaceURI(String prefix) {
		return xmlNode.getNamespaceFor(prefix);
	}
	
	/*
		Returns the prefix matching a specified namespace URI
	*/ 
	public virtual String lookupPrefix(String nsURI) {
		return xmlNode.getPrefixFor(nsURI);
	}
							
	
	/*
		Returns true if a node has any attributes, otherwise it returns false	
	*/
	public virtual Boolean hasAttributes() {
		return xmlNode.getAttributeCount() > 0;
	}	
	
	/*
		Returns true if a node has any child nodes, otherwise it returns false
	*/	
	public virtual Boolean hasChildNodes() {
		Dom.XmlNode [] nativeKids = xmlNode.getChildren();
		return nativeKids != null && !nativeKids.isEmpty(); 	
	}
	
	/*
		Returns whether the specified namespaceURI is the default	
	*/
	public virtual Boolean isDefaultNamespace(String uri) {
		return uri == this.xmlNode.getNamespace();
	}
	
	/*
		Removes a child node
	*/
	public virtual Boolean removeChild (TG_XmlNode child) {
		return this.xmlNode.removeChild(child.xmlNode);
	}
	
	/**
		Clones this node.
		@param deep to clone child nodes too.
	*/
	public virtual TG_XmlNode cloneNode (boolean deep) {
		// setting ownerdocument of cloned node as null, we don't want this
		return new TG_XmlNode(TG_XmlUtils.clone(this.xmlNode, deep));
	}
	
	/**
		Appends the given node to this node
		@param nodeToAppend the node that will get appended
		@return The node that was actually added
	*/
	public virtual TG_XmlNode appendChild (TG_XmlNode nodeToAppend) {
		return appendChild(nodeToAppend.xmlNode);
	}

	/**
		Appends the given node to this node
		@param nodeToAppend the node that will get appended
		@return The node that was actually added
	*/
	public virtual TG_XmlNode appendChild (Dom.XmlNode nodeToAppend) {
		Dom.XmlNode ret = TG_XmlUtils.appendChild(this.xmlNode, nodeToAppend);
		return ret != null ? new TG_XmlNode(ret) : null;
	}


	/*
		Returns Xml Rep of this node
	*/
	public String toXmlString() {
		return TG_XmlUtils.toXmlString(xmlNode);
	}
	
	
	static void loadChildElementsForTagName(Dom.XmlNode fromNode, String nam, string nameSpace, List<TG_XmlNode> ret) {
		// Check if this node is matching the mentioned tag name.
		if (fromNode.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(fromNode.getNamespace()))) 
				ret.add(new TG_XmlNode(fromNode)); 
		
		// Add kids and their kids
		for (Dom.XmlNode kid: fromNode.getChildElements()) {
			if (kid.getChildElements().isEmpty()) {
				if (kid.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(kid.getNamespace())))
					ret.add(new TG_XmlNode(kid));
			} else {
				loadChildElementsForTagName(kid, nam, nameSpace, ret);
			}
		} 
	}

	static TG_XmlNode loadChildElementForTagName(Dom.XmlNode fromNode, String nam, string nameSpace) {
		// Check if this node is matching the mentioned tag name.
		if (fromNode.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(fromNode.getNamespace()))) 
			return new TG_XmlNode(fromNode); 
		
		// Add kids and their kids
		for (Dom.XmlNode kid: fromNode.getChildElements()) {
			if (kid.getChildElements().isEmpty()) {
				if (kid.getName().equalsIgnoreCase(nam) && (nameSpace == null || nameSpace.equalsIgnoreCase(kid.getNamespace())))
					return new TG_XmlNode(kid);
			} else {
				TG_XmlNode ret = loadChildElementForTagName(kid, nam, nameSpace);
				if (ret != null) return ret;
			}
		} 
		return null;
	}
	
}