/////////////////////////////////////////////////////DEMO.JS///////////////////////////////////////////////////////////////////////


var demo = {
			
		init: function(view) {
		
			this.view = view;
			carousel = view.find('#rs-carousel');
                        value = 'horizontal';
                        carousel.carousel('option', "orientation", value);
                        var opts = {};
			opts["itemsPerPage"] = "3";
			opts["itemsPerTransition"] = "1";
			opts["speed"] = "slow";
			opts["autoScroll"] = true;
                        opts["pagination"] = false;
                        opts.translate3d = Modernizr && Modernizr.csstransforms3d;
                        opts.touch = Modernizr && Modernizr.touch;
                        carousel.carousel(opts);
                        
                        // 
                        // Option And Values
			//"itemsPerPage" values ="auto", "1","2","3","4"
                        //"itemsPerTransition" values="auto" "1", "2","3","4","5","6","7","8"
			//"speed" values = "slow","normal","fast"
			//"easing" values = "swing","linear"
			//"pagination" values = "true","false"
                        //"nextPrevActions" values = "true","false"
                        //"autoScroll" values = "true","false"
                        //"continuous" values = "true","false"
                }			
	};


/*
 * jquery.rs.carousel.js v0.8.6
 *
 * Copyright (c) 2011 Richard Scarrott
 * http://www.richardscarrott.co.uk
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * Depends:
 *  jquery.js v1.4+
 *  jquery.ui.widget.js v1.8+
 *
 */
 
(function ($, undefined) {

    var _super = $.Widget.prototype,
        horizontal = {
            pos: 'left',
            pos2: 'right',
            dim: 'width'
        },
        vertical = {
            pos: 'top',
            pos2: 'bottom',
            dim: 'height'
        };
    
    $.widget('rs.carousel', {

        options: {
            itemsPerPage: 'auto',
            itemsPerTransition: 'auto',
            orientation: 'horizontal',
            loop: false,
            nextPrevActions: true,
            insertPrevAction: function () {
                return $('<a href="#" class="rs-carousel-action-prev">Prev</a>').appendTo(this);
            },
            insertNextAction: function () {
                return $('<a href="#" class="rs-carousel-action-next">Next</a>').appendTo(this);
            },
            pagination: true,
            insertPagination: function (pagination) {
                return $(pagination).insertAfter($(this).find('.rs-carousel-mask'));
            },
            speed: 'normal',
            easing: 'swing',

            // callbacks
            create: null,
            before: null,
            after: null
        },

        _create: function () {

            this.page = 1;
            this._elements();
            this._defineOrientation();
            this._addMask();
            this._addNextPrevActions();
            this.refresh(false);

            return;
        },

        // caches DOM elements
        _elements: function () {

            var elems = this.elements = {},
                baseClass = '.' + this.widgetBaseClass;

            elems.mask = this.element.children(baseClass + '-mask');
            elems.runner = this.element.find(baseClass + '-runner').first();
            elems.items = elems.runner.children(baseClass + '-item');
            elems.pagination = undefined;
            elems.nextAction = undefined;
            elems.prevAction = undefined;

            return;
        },

        _addClasses: function () {

            if (!this.oldClass) {
                this.oldClass = this.element[0].className;
            }

            this._removeClasses();

            var baseClass = this.widgetBaseClass,
                classes = [];

            classes.push(baseClass);
            classes.push(baseClass + '-' + this.options.orientation);
            classes.push(baseClass + '-items-' + this.options.itemsPerPage);

            this.element.addClass(classes.join(' '));

            return;
        },

        // removes rs-carousel* classes
        _removeClasses: function () {

            var self = this,
                widgetClasses = [];

            this.element.removeClass(function (i, classes) {

                $.each(classes.split(' '), function (i, value) {

                    if (value.indexOf(self.widgetBaseClass) !== -1) {
                        widgetClasses.push(value);
                    }

                });

                return widgetClasses.join(' ');

            });

            return;
        },

        // defines obj to hold strings based on orientation for dynamic method calls
        _defineOrientation: function () {

            if (this.options.orientation === 'horizontal') {
                this.isHorizontal = true;
                this.helperStr = horizontal;
            }
            else {
                this.isHorizontal = false;
                this.helperStr = vertical;
            }

            return;
        },

        // adds masking div (aka clipper)
        _addMask: function () {

            var elems = this.elements;

            // already exists in markup
            if (elems.mask.length) {
                return;
            }

            elems.mask = elems.runner
                .wrap('<div class="' + this.widgetBaseClass + '-mask" />')
                .parent();

            // indicates whether mask was dynamically added or already existed in mark-up
            this.maskAdded = true;

            return;
        },

        // sets runners width
        _setRunnerWidth: function () {

            if (!this.isHorizontal) {
                return;
            }
            
            var self = this;

            this.elements.runner.width(function () {
                return self._getItemDim() * self.getNoOfItems();
            });

            return;
        },

        // sets itemDim to the dimension of first item incl. margin
        _getItemDim: function () {

            // is this ridiculous??
            return this.elements.items
                ['outer' + this.helperStr.dim.charAt(0).toUpperCase() + this.helperStr.dim.slice(1)](true);

        },

        getNoOfItems: function () {
            
            return this.elements.items.length;
             
        },

        // adds next and prev links
        _addNextPrevActions: function () {

            if (!this.options.nextPrevActions) {
                return;
            }

            var self = this,
                elems = this.elements,
                opts = this.options;
                
            this._removeNextPrevActions();

            elems.prevAction = opts.insertPrevAction.apply(this.element[0])
                .bind('click.' + this.widgetName, function (e) {
                    e.preventDefault();
                    self.prev();
                });

            elems.nextAction = opts.insertNextAction.apply(this.element[0])
                .bind('click.' + this.widgetName, function (e) {
                    e.preventDefault();
                    self.next();
                });
            
            return;
        },

        _removeNextPrevActions: function () {
        
            var elems = this.elements;
        
            if (elems.nextAction) {
                elems.nextAction.remove();
                elems.nextAction = undefined;
            }   
            
            if (elems.prevAction) {
                elems.prevAction.remove();
                elems.prevAction = undefined;
            }
            
            return; 
        },

        // adds pagination links and binds associated events
        _addPagination: function () {

            if (!this.options.pagination) {
                return;
            }

            var self = this,
                elems = this.elements,
                opts = this.options,
                baseClass = this.widgetBaseClass,
                pagination = $('<ol class="' + baseClass + '-pagination" />'),
                links = [],
                noOfPages = this.getNoOfPages(),
                i;
                
            this._removePagination();

            for (i = 1; i <= noOfPages; i++) {
                links[i] = '<li class="' + baseClass + '-pagination-link"><a href="#page-' + i + '">' + i + '</a></li>';
            }

            pagination
                .append(links.join(''))
                .delegate('a', 'click.' + this.widgetName, function (e) {
                    e.preventDefault();
                    self.goToPage(parseInt(this.hash.split('-')[1], 10));
                });
            
            this.elements.pagination = this.options.insertPagination.call(this.element[0], pagination);
            
            return;
        },

        _removePagination: function () {
        
            if (this.elements.pagination) {
                this.elements.pagination.remove();
                this.elements.pagination = undefined;
            }
            
            return;
        },

        // sets array of pages
        _setPages: function () {

            var index = 1,
                page = 0,
                noOfPages = this.getNoOfPages();
                
            this.pages = [];
            
            while (page < noOfPages) {
                
                // if index is greater than total number of items just go to last
                if (index > this.getNoOfItems()) {
                    index = this.getNoOfItems();
                }

                this.pages[page] = index;
                index += this.getItemsPerTransition(); // this.getItemsPerPage(index);
                page++;
            }

            return;
        },

        getPages: function () {
            
            return this.pages;

        },

        // returns noOfPages
        getNoOfPages: function () {

            var itemsPerTransition = this.getItemsPerTransition();

            // #18 - ensure we don't return Infinity
            if (itemsPerTransition <= 0) {
                return 0;
            }

            return Math.ceil((this.getNoOfItems() - this.getItemsPerPage()) / itemsPerTransition) + 1;

        },

        // returns options.itemsPerPage. If not a number it's calculated based on maskdim
        getItemsPerPage: function () {

            // if itemsPerPage of type number don't dynamically calculate
            if (typeof this.options.itemsPerPage === 'number') {
                return this.options.itemsPerPage;
            }
            
            return Math.floor(this._getMaskDim() / this._getItemDim());

        },

        getItemsPerTransition: function () {

            if (typeof this.options.itemsPerTransition === 'number') {
                return this.options.itemsPerTransition;
            }

            return this.getItemsPerPage();
            
        },

        _getMaskDim: function () {
            
            return this.elements.mask[this.helperStr.dim]();

        },

        next: function (animate) {

            var page = this.page + 1;

            if (this.options.loop && page > this.getNoOfPages()) {
                page = 1;
            }
            
            this.goToPage(page, animate);

            return;
        },

        prev: function (animate) {

            var page = this.page - 1;

            if (this.options.loop && page < 1) {
                page = this.getNoOfPages();
            }
            
            this.goToPage(page, animate);

            return;
        },

        // shows specific page (one based)
        goToPage: function (page, animate) {

            if (!this.options.disabled && this._isValid(page)) {
                this.prevPage = this.page;
                this.page = page;
                this._go(animate);
            }
            
            return;
        },

        // returns true if page index is valid, false if not
        _isValid: function (page) {
            
            if (page <= this.getNoOfPages() && page >= 1) {
                return true;
            }
            
            return false;
        },

        // returns valid page index
        _makeValid: function (page) {
                
            if (page < 1) {
                page = 1;
            }
            else if (page > this.getNoOfPages()) {
                page = this.getNoOfPages();
            }

            return page;
        },

        // abstract _slide to easily override within extensions
        _go: function (animate) {
            
            this._slide(animate);

            return;
        },

        _slide: function (animate) {

            var self = this,
                animate = animate === false ? false : true, // undefined should pass as true
                speed = animate ? this.options.speed : 0,
                animateProps = {},
                lastPos = this._getAbsoluteLastPos(),
                pos = this.elements.items
                    .eq(this.pages[this.page - 1] - 1) // arrays and .eq() are zero based, carousel is 1 based
                        .position()[this.helperStr.pos];

            // check pos doesn't go past last posible pos
            if (pos > lastPos) {
                pos = lastPos;
            }

            // might be nice to put animate on event object:
            // $.Event('slide', { animate: animate }) - would require jQuery 1.6+
            this._trigger('before', null, {
                elements: this.elements,
                animate: animate
            });

            animateProps[this.helperStr.pos] = -pos;
            this.elements.runner
                .stop()
                .animate(animateProps, speed, this.options.easing, function () {
                    
                    self._trigger('after', null, {
                        elements: self.elements,
                        animate: animate
                    });

                });
                
            this._updateUi();

            return;
        },

        // gets lastPos to ensure runner doesn't move beyond mask (allowing mask to be any width and the use of margins)
        _getAbsoluteLastPos: function () {
            
            var lastItem = this.elements.items.eq(this.getNoOfItems() - 1);
            
            return lastItem.position()[this.helperStr.pos] + this._getItemDim() -
                    this._getMaskDim() - parseInt(lastItem.css('margin-' + this.helperStr.pos2), 10);

        },

        // updates pagination, next and prev link status classes
        _updateUi: function () {

            if (this.options.pagination) {
                this._updatePagination();
            }

            if (this.options.nextPrevActions) {
                this._updateNextPrevActions();
            }

            return;
        },

        _updatePagination: function () {
            
            var baseClass = this.widgetBaseClass,
                activeClass = baseClass + '-pagination-link-active';

            this.elements.pagination
                .children('.' + baseClass + '-pagination-link')
                    .removeClass(activeClass)
                    .eq(this.page - 1)
                        .addClass(activeClass);

            return;
        },

        _updateNextPrevActions: function () {
            
            var elems = this.elements,
                page = this.page,
                disabledClass = this.widgetBaseClass + '-action-disabled';

            elems.nextAction
                .add(elems.prevAction)
                    .removeClass(disabledClass);

            if (!this.options.loop) {
                
                if (page === this.getNoOfPages()) {
                    elems.nextAction.addClass(disabledClass);
                }
                else if (page === 1) {
                    elems.prevAction.addClass(disabledClass);
                }

            }

            return;
        },

        // formalise appending items as continuous adding complexity by inserting
        // cloned items
        add: function (items) {

            this.elements.runner.append(items);
            this.refresh();

            return;
        },

        remove: function (selector) {
            
            if (this.getNoOfItems() > 0) {

                this.elements.items
                    .filter(selector)
                    .remove();

                this.refresh();
            }

            return;
        },

        // handles option updates
        _setOption: function (option, value) {

            var requiresRefresh = [
                'itemsPerPage',
                'itemsPerTransition',
                'orientation'
            ];      

            _super._setOption.apply(this, arguments);

            switch (option) {

            case 'orientation':
            
                this.elements.runner
                    .css(this.helperStr.pos, '')
                    .width('');

                this._defineOrientation();

                break;

            case 'pagination':

                if (value) {
                    this._addPagination();
                    this._updateUi();
                }
                else {
                    this._removePagination();
                }

                break;

            case 'nextPrevActions':

                if (value) {
                    this._addNextPrevActions();
                    this._updateUi();
                }
                else {
                    this._removeNextPrevActions();
                }

                break;

            case 'loop':

                this._updateUi();

                break;
            }

            if ($.inArray(option, requiresRefresh) !== -1) {
                this.refresh();
            }

            return;
        },

        // if no of items is less than items per page we disable carousel
        _checkDisabled: function () {
            
            if (this.getNoOfItems() <= this.getItemsPerPage()) {
                this.elements.runner.css(this.helperStr.pos, '');
                this.disable();
            }
            else {
                this.enable();
            }

            return;
        },

        // refresh carousel
        refresh: function (recache) {

            // assume true (undefined should pass condition)
            if (recache !== false) {
                this._recacheItems();
            }

            this._addClasses();
            this._setPages();
            this._addPagination();
            this._checkDisabled();
            this._setRunnerWidth();
            this.page = this._makeValid(this.page);
            this.goToPage(this.page, false);

            return;
        },

        // re-cache items in case new items have been added,
        // moved to own method so continuous can easily override
        // to avoid clones
        _recacheItems: function () {

            this.elements.items = this.elements.runner
                .children('.' + this.widgetBaseClass + '-item');

            return;
        },

        // returns carousel to original state
        destroy: function () {

            var elems = this.elements,
                cssProps = {};

            this.element
                .removeClass()
                .addClass(this.oldClass);
            
            if (this.maskAdded) {
                elems.runner
                    .unwrap('.' + this.widgetBaseClass + '-mask');
            }

            cssProps[this.helperStr.pos] = '';
            cssProps[this.helperStr.dim] = '';
            elems.runner.css(cssProps);
            
            this._removePagination();
            this._removeNextPrevActions();
            
            _super.destroy.apply(this, arguments);

            return;
        },

        getPage: function () {
            
            return this.page;

        },

        getPrevPage: function () {
            
            return this.prevPage;

        },

        // item can be $obj, element or 1 based index
        goToItem: function (index, animate) {

            // assume element or jQuery obj
            if (typeof index !== 'number') {
                index = this.elements.items.index(index) + 1;
            }

            if (index <= this.getNoOfItems()) {
                this.goToPage(Math.ceil(index / this.getItemsPerTransition()), animate);
            }

            return;
        }

    });
    
    $.rs.carousel.version = '0.8.6';

})(jQuery);






/////////////////////////////////////////////////////////////////////JQUERY.RS.CAROUSEL-AUTOSCROLL.JS///////////////////////////////////////////////////////



/*
 * jquery.rs.carousel-autoscroll v0.8.6
 *
 * Copyright (c) 2011 Richard Scarrott
 * http://www.richardscarrott.co.uk
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * Depends:
 *  jquery.js v1.4+
 *  jquery.ui.widget.js v1.8+
 *  jquery.rs.carousel.js v0.8.6+
 *
 */
 
(function($, undefined) {

    var _super = $.rs.carousel.prototype;
    
    $.widget('rs.carousel', $.rs.carousel, {
    
        options: {
            pause: 8000,
            autoScroll: false
        },
        
        _create: function() {
        
            _super._create.apply(this);
            
            if (!this.options.autoScroll) {
                return;
            }
            
            this._bindAutoScroll();
            this._start();
            
            return;
        },
        
        _bindAutoScroll: function() {
            
            if (this.autoScrollInitiated) {
                return;
            }
            
            this.element
                .bind('mouseenter.' + this.widgetName, $.proxy(this, '_stop'))
                .bind('mouseleave.' + this.widgetName, $.proxy(this, '_start'));
                
            this.autoScrollInitiated = true;
            
            return;
        },
        
        _unbindAutoScroll: function() {
            
            this.element
                .unbind('mouseenter.' + this.widgetName)
                .unbind('mouseleave.' + this.widgetName);
                
            this.autoScrollInitiated = false;
            
            return;
        },
        
        _start: function() {
        
            var self = this;
            
            // ensures interval isn't started twice
            this._stop();
            
            this.interval = setInterval(function() {

                if (self.page === self.getNoOfPages()) {
                    self.goToPage(1);
                }
                else {
                    self.next();
                }
            
            }, this.options.pause);
            
            return;
        },
        
        _stop: function() {
        
            clearInterval(this.interval);
            
            return;     
        },
        
        _setOption: function (option, value) {
        
            _super._setOption.apply(this, arguments);
            
            switch (option) {
                
            case 'autoScroll':
            
                this._stop();
                
                if (value) {
                    this._bindAutoScroll();
                    this._start();
                }
                else {
                    this._unbindAutoScroll();
                }
                
                break;
                    
            }
            
            return;
        },
        
        destroy: function() {
            
            this._stop();
            _super.destroy.apply(this);
            
            return;
        }
        
    });
    
})(jQuery);




/////////////////////////////////////////////////////////////////jquery.rs.carousel-continuous//////////////////////////////////////////////////////////


/*
 * jquery.rs.carousel-continuous v0.8.6
 *
 * Copyright (c) 2011 Richard Scarrott
 * http://www.richardscarrott.co.uk
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * Depends:
 *  jquery.js v1.4+
 *  jquery.ui.widget.js v1.8+
 *  jquery.rs.carousel.js v0.8.6+
 *
 */
 
(function($, undefined) {

    var _super = $.rs.carousel.prototype;
    
    $.widget('rs.carousel', $.rs.carousel, {
    
        options: {
            continuous: false
        },
        
        _create: function () {
        
            _super._create.apply(this, arguments);

            if (this.options.continuous) {

                this._setOption('loop', true);
                this._addClonedItems();
                this.goToPage(1, false); // go to page to ensure we ignore clones

            }
            
            return;
        },
        
        // appends and prepends items to provide illusion of continuous scrolling
        _addClonedItems: function () {

            if (this.options.disabled) {
                this._removeClonedItems();
                return;
            }
        
            var elems = this.elements,
                cloneCount = this._getCloneCount(),
                cloneClass = this.widgetBaseClass + '-item-clone';

            this._removeClonedItems();
        
            elems.clonedBeginning = this.elements.items
                .slice(0, cloneCount)
                    .clone()
                        .addClass(cloneClass);

            elems.clonedEnd = this.elements.items
                .slice(-cloneCount)
                    .clone()
                        .addClass(cloneClass);
            
            elems.clonedBeginning.appendTo(elems.runner);
            elems.clonedEnd.prependTo(elems.runner);
            
            return;
        },

        _removeClonedItems: function () {
        
            var elems = this.elements;
        
            if (elems.clonedBeginning) {
                elems.clonedBeginning.remove();
                elems.clonedBeginning = undefined;
            }
            
            if (elems.clonedEnd) {
                elems.clonedEnd.remove();
                elems.clonedEnd = undefined;
            }
        
        },

        // number of cloned items should equal itemsPerPage or, if greater, itemsPerTransition
        _getCloneCount: function () {

            var visibleItems = Math.ceil(this._getMaskDim() / this._getItemDim()),
                itemsPerTransition = this.getItemsPerTransition();

            return visibleItems >= itemsPerTransition ? visibleItems : itemsPerTransition;
        },

        // needs to be overridden to take into account cloned items
        _setRunnerWidth: function () {

            if (!this.isHorizontal) {
                return;
            }

            var self = this;
            
            if (this.options.continuous) {
                
                this.elements.runner.width(function () {
                    return self._getItemDim() * (self.getNoOfItems() + (self._getCloneCount() * 2));
                });

            }
            else {
                _super._setRunnerWidth.apply(this, arguments);
            }

            return;
        },

        _slide: function (animate) {

            var self = this,
                itemIndex,
                cloneIndex;

            // if first or last page jump to cloned before slide
            if (this.options.continuous) {

                // this criteria means using goToPage(1) when on last page will act as continuous,
                // good thing is it means autoScrolls _start method doesn't have to be overridden
                // anymore, but is it desired?
                if (this.page === 1 && this.prevPage === this.getNoOfPages()) {

                    // jump to clonedEnd
                    this.elements.runner.css(this.helperStr.pos, function () {

                        // get item index of old page in context of clonedEnd
                        itemIndex = self.pages[self.prevPage - 1];

                        cloneIndex = self.elements.items
                            .slice(-self._getCloneCount())
                            .index(self.elements.items.eq(itemIndex - 1));

                        return -self.elements.clonedEnd
                            .eq(cloneIndex)
                                .position()[self.helperStr.pos];
                    });

                }
                else if (this.page === this.getNoOfPages() && this.prevPage === 1) {

                    // jump to clonedBeginning
                    this.elements.runner.css(this.helperStr.pos, function () {
                        return -self.elements.clonedBeginning
                            .first()
                                .position()[self.helperStr.pos];
                    });
                                                
                }

            }

            // continue
            _super._slide.apply(this, arguments);

            return;
        },

        // don't need to take into account itemsPerPage when continuous as there's no absolute last pos
        getNoOfPages: function () {
            
            var itemsPerTransition;

            if (this.options.continuous) {

                itemsPerTransition = this.getItemsPerTransition();

                if (itemsPerTransition <= 0) {
                    return 0;
                }

                return Math.ceil(this.getNoOfItems() / itemsPerTransition);
            }

            return _super.getNoOfPages.apply(this, arguments);
        },

        // not required as cloned items fill space
        _getAbsoluteLastPos: function () {
            
            if (this.options.continuous) {
                return;
            }

            return _super._getAbsoluteLastPos.apply(this, arguments);
        },

        refresh: function() {

            _super.refresh.apply(this, arguments);
            
            if (this.options.continuous) {
                this._addClonedItems();
                this.goToPage(this.page, false);
            }
            
            return;
        },

        // override to avoid clones
        _recacheItems: function () {

            var baseClass = '.' + this.widgetBaseClass;

            this.elements.items = this.elements.runner
                .children(baseClass + '-item')
                    .not(baseClass + '-item-clone');

            return;
        },

        add: function (items) {

            if (this.elements.items.length) {

                this.elements.items
                    .last()
                        .after(items);

                this.refresh();

                return;
            }
            
            // cloned items won't exist so use add from prototype (appends to runner)
            _super.add.apply(this, arguments);

            return;
        },

        _setOption: function (option, value) {
            
            _super._setOption.apply(this, arguments);
            
            switch (option) {
                
            case 'continuous':

                this._setOption('loop', value);

                if (!value) {
                    this._removeClonedItems();
                }
                
                this.refresh();
                
                break;
            }

            return;
        },
        
        destroy: function() {
            
            this._removeClonedItems();
            
            _super.destroy.apply(this);
            
            return;
        }
        
    });
    
})(jQuery);


//////////////////////////////////////////////////////////////////jquery.rs.carousel-touch///////////////////////////////////////////////////////////////

/*
 * jquery.rs.carousel-touch v0.8.6
 *
 * Copyright (c) 2011 Richard Scarrott
 * http://www.richardscarrott.co.uk
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * Depends:
 *  jquery.js v1.4+
 *  jquery.translate3d.js v0.1+ // if passing in translate3d true for hardware acceleration
 *  jquery.event.drag.js v2.1.0+
 *  jquery.ui.widget.js v1.8+
 *  jquery.rs.carousel.js v0.8.6+
 *
 */

(function ($) {

    var _super = $.Widget.prototype;
    
    // custom drag, if supported it uses 'translate3d' instead of 'left / top'
    // for hardware acceleration in iOS et al.
    $.widget('rs.draggable3d', {
    
        options: {
            axis: 'x',
            translate3d: false
        },
        
        _create: function () {

            var self = this;

            this.element
                .bind('dragstart', function (e) {
                    self._mouseStart(e);
                })
                .bind('drag', function (e) {
                    self._mouseDrag(e);
                })
                .bind('dragend', function (e) {
                    self._mouseStop(e);
                });
            
            return;
        },
        
        _getPosStr: function () {
            
            return this.options.axis === 'x' ? 'left' : 'top';
            
        },
        
        _mouseStart: function(e) {
            
            this.mouseStartPos = this.options.axis === 'x' ? e.pageX : e.pageY;
            
            if (this.options.translate3d) {
                this.runnerPos = this.element.css('translate3d')[this.options.axis];
            }
            else {
                this.runnerPos = parseInt(this.element.position()[this._getPosStr()], 10);
            }
            
            this._trigger('start', e);

            return;
        },
        
        _mouseDrag: function(e) {
        
            var page = this.options.axis === 'x' ? e.pageX : e.pageY,
                pos = (page - this.mouseStartPos) + this.runnerPos,
                cssProps = {};
            
            if (this.options.translate3d) {
                cssProps.translate3d = this.options.axis === 'x' ? {x: pos} : {y: pos};
            }
            else {
                cssProps[this._getPosStr()] = pos;
            }
            
            this.element.css(cssProps);
            
            return;
        },
        
        _mouseStop: function (e) {
            
            this._trigger('stop', e);
            
            return;
        },
        
        destroy: function () {
        
            var cssProps = {};
            
            if (this.options.translate3d) {
                cssProps.translate3d = {};
            }
            else {
                cssProps[this._getPosStr()] = '';
            }
            
            this.element.css(cssProps);
            //this._mouseDestroy();
            _super.destroy.apply(this);
            
            return;
        }
        
    });
    
})(jQuery);



// touch extension
(function ($) {
    
    var _super = $.rs.carousel.prototype;
        
    $.widget('rs.carousel', $.rs.carousel, {
    
        options: {
            touch: false,
            translate3d: false,
            sensitivity: 0.8
        },
        
        _create: function () {
            
            _super._create.apply(this);
            
            var self = this;

            if (this.options.touch) {
                
                this.elements.runner
                    .draggable3d({
                        translate3d: this.options.translate3d,
                        axis: this._getAxis(),
                        start: function (e) {
                            e = e.originalEvent.touches ? e.originalEvent.touches[0] : e;
                            self._dragStartHandler(e);
                        },
                        stop: function (e) {
                            e = e.originalEvent.touches ? e.originalEvent.touches[0] : e;
                            self._dragStopHandler(e);
                        }
                    });

            }
                
            // bind CSS transition callback
            if (this.options.translate3d) {
                this.elements.runner.bind('webkitTransitionEnd transitionend oTransitionEnd', function (e) {
                    self._trigger('after', null, {
                        elements: self.elements,
                        animate: animate
                    });
                    e.preventDefault(); // stops page from jumping to top...
                });
            }
            
            return;
        },
        
        _getAxis: function () {
            
            return this.isHorizontal ? 'x' : 'y';
        
        },
        
        _dragStartHandler: function (e) {
        
            // remove transition class to ensure drag doesn't transition
            if (this.options.translate3d) {
                this.elements.runner.removeClass(this.widgetBaseClass + '-runner-transition');
            }
        
            this.startTime = this._getTime();
            
            this.startPos = {
                x: e.pageX,
                y: e.pageY
            };
            
            return;
        },
        
        _dragStopHandler: function (e) {
        
            var time,
                distance,
                speed,
                direction,
                axis = this._getAxis();
                
            // if touch direction changes start date should prob be reset to correctly determine speed...
            this.endTime = this._getTime();
            
            time = this.endTime - this.startTime;
            
            this.endPos = {
                x: e.pageX,
                y: e.pageY
            };
            
            distance = Math.abs(this.startPos[axis] - this.endPos[axis]);
            speed = distance / time;
            direction = this.startPos[axis] > this.endPos[axis] ? 'next' : 'prev';
            
            if (speed > this.options.sensitivity || distance > (this._getItemDim() * this.getItemsPerTransition() / 2)) {
                if ((this.page === this.getNoOfPages() && direction === 'next')
                    || (this.page === 1 && direction === 'prev')) {
                    this.goToPage(this.page);
                }
                else {
                    this[direction]();
                }
            }
            else {
                this.goToPage(this.page); // go back to current page
            }
            
            return;
        },
        
        _getTime: function () {
            
            var date = new Date();
            return date.getTime();
        
        },
        
        // override _slide to work with tanslate3d - TODO: remove duplication
        _slide: function (animate) {

            var self = this,
                animate = animate === false ? false : true, // undefined should pass as true
                speed = animate ? this.options.speed : 0,
                animateProps = {},
                lastPos = this._getAbsoluteLastPos(),
                pos = this.elements.items
                    .eq(this.pages[this.page - 1] - 1) // arrays and .eq() are zero based, carousel is 1 based
                        .position()[this.helperStr.pos];

            // check pos doesn't go past last posible pos
            if (pos > lastPos) {
                pos = lastPos;
            }

            this._trigger('before', null, {
                elements: this.elements,
                animate: animate
            });
            
            if (this.options.translate3d) {
                
                this.elements.runner
                    .addClass(this.widgetBaseClass + '-runner-transition')
                    .css({
                        translate3d: this.isHorizontal ? {x: -pos} : {y: -pos}
                    });
                
            }
            else {
                
                animateProps[this.helperStr.pos] = -pos;
                animateProps.useTranslate3d = true; // what the hell is this...
                this.elements.runner
                    .stop()
                    .animate(animateProps, speed, this.options.easing, function () {
                        
                        self._trigger('after', null, {
                            elements: self.elements,
                            animate: animate
                        });

                    });
            }
                
            this._updateUi();
            
            return;
        },
        
        _setOption: function (option, value) {
        
            _super._setOption.apply(this, arguments);
            
            switch (option) {
                
            case 'orientation':
                this._switchAxis();
                break;
            }
            
            return;
        },
        
        _switchAxis: function () {
        
            this.elements.runner.draggable3d('option', 'axis', this._getAxis());
            
            return;
        },
        
        destroy: function () {
            
            this.elements.runner.draggable3d('destroy');
            _super.destroy.apply(this);
            
            return;
        }
        
    });

})(jQuery);




$(document).ready(function() {
		
                    demo.init($('#container'));
			
			// example of hardware support (translate3d) detection, uses Modernizr
			$('#rs-carousel').carousel({
				translate3d: $.browser.webkit && Modernizr && Modernizr.csstransforms3d
			});
			
		});
                
