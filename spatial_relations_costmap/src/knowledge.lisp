;;; Copyright (c) 2012, Gayane Kazhoyan <kazhoyan@in.tum.de>
;;; All rights reserved.
;;; 
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;; 
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of the Intelligent Autonomous Systems Group/
;;;       Technische Universitaet Muenchen nor the names of its contributors 
;;;       may be used to endorse or promote products derived from this software 
;;;       without specific prior written permission.
;;; 
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(in-package :spatial-relations-costmap)

(def-fact-group costmap-metadata ()
  (<- (costmap-size 7 7))
  (<- (costmap-origin -3.5 -3.5))
  (<- (costmap-resolution 0.01))

  (<- (costmap-padding 0.38))
  (<- (costmap-manipulation-padding 0.38))
  (<- (costmap-in-reach-distance 1.0))
  (<- (costmap-reach-minimal-distance 0.2)))

;; (def-fact-group costmap-metadata ()
;;   (<- (costmap-size 25 25))
;;   (<- (costmap-origin -12.5 -12.5))
;;   (<- (costmap-resolution 0.05))

;;   (<- (costmap-padding 0.35))
;;   (<- (costmap-manipulation-padding 0.35))
;;   (<- (costmap-in-reach-distance 1.0))
;;   (<- (costmap-reach-minimal-distance 0.1)))

(def-fact-group semantic-map-data ()
  (<- (semantic-map-obj btr::sem-map))
  (<- (kitchen-island-z 0.8399999737739563d0)))

;; TODO change after near and far is refactored
;; TODO maybe remove collision costmap completely, but rather just disable and uncomment
(def-fact-group costmap-params ()
  (<- (collision-costmap-padding-in-meters 0.01d0)) ; for collision costmap
  (<- (near-costmap-gauss-std 1.0d0)) ; reference object size dependent maybe TODO
  (<- (costmap-width-in-obj-size-percentage-near 1.0d0)) ; for far-from and near costmaps
  (<- (costmap-width-in-obj-size-percentage-far 0.5d0)))  ; (percents of objs size average)

(def-fact-group spatial-relations-knowledge ()
  ;; object shape related
  (<- (shape :circle))
  (<- (shape :oval))
  (<- (shape :rectangle))
  (<- (shape :complex))
  ;;
  (<- (object-type-shape pot :complex))
  (<- (object-type-shape bowl :circle))
  (<- (object-type-shape mondamin :oval))
  (<- (object-type-shape mug :complex))
  (<- (object-type-shape plate :circle))
  (<- (object-type-shape fork :rectangle))
  (<- (object-type-shape knife :rectangle))
  ;;  
  (<- (object-shape ?world ?object-name ?shape)
    (household-object-type ?world ?object-name ?object-type)
    (object-type-shape ?object-type ?shape))
  ;;
  (<- (object-type-handle-size pot 0.12d0)) ; both handles together
  (<- (object-type-handle-size mug 0.04d0))
  ;;
  (<- (object-handle-size ?world ?obj-name ?handle-size)
    (household-object-type ?world ?obj-name ?object-type)
    (object-type-handle-size ?object-type ?handle-size))

  ;; padding related
  (<- (object-type-padding-size pot 0.04d0))
  (<- (object-type-padding-size bowl 0.03d0))
  (<- (object-type-padding-size mondamin 0.01d0))
  (<- (object-type-padding-size mug 0.01d0))
  (<- (object-type-padding-size plate 0.005d0))
  (<- (object-type-padding-size fork 0.005d0))
  (<- (object-type-padding-size knife 0.005d0))
  ;;
  (<- (padding-size ?world ?object-name ?padding)
    (household-object-type ?world ?object-name ?object-type)
    (object-type-padding-size ?object-type ?padding))
  
  ;; costmap threshold related
  ;; depends on how flexible you want the positioning to be,
  ;; e.g. in case of cluttered scenes etc.
  (<- (object-type-costmap-threshold pot 0.85d0))
  (<- (object-type-costmap-threshold bowl 0.9d0))
  (<- (object-type-costmap-threshold mondamin 0.9d0))
  (<- (object-type-costmap-threshold mug 0.8d0)) ; 0.97d0))
  (<- (object-type-costmap-threshold plate 0.8d0)) ; 0.999d0))
  (<- (object-type-costmap-threshold fork 0.8d0)) ; 0.99d0))
  (<- (object-type-costmap-threshold knife 0.8d0)) ; 0.99d0))
  ;;
  (<- (object-costmap-threshold ?world ?object-name ?threshold)
    (household-object-type ?world ?object-name ?object-type)
    (object-type-costmap-threshold ?object-type ?threshold))

  ;; object orientation related
  (<- (orientation-samples 4))
  (<- (orientation-samples-step ?samples-step)
    (lisp-fun symbol-value pi ?pi)
    (lisp-fun / ?pi 18 ?samples-step))
  ;;
  (<- (orientation-matters ?obj-name)
    (bullet-world ?world)
    (object ?world ?obj-name)
    (or (household-object-type ?world ?obj-name knife)
        (household-object-type ?world ?obj-name fork)))

  ;; table setting related
  (<- (paddings-list kitchen-island table-setting (-0.04d0 0.01d0 0.03d0 0.8d0)))
  (<- (paddings-list "CounterTop208" table-setting (-0.04d0 0.01d0 0.03d0 0.8d0)))
  (<- (preferred-supporting-object-side kitchen-island table-setting :-))
  (<- (preferred-supporting-object-side "CounterTop208" table-setting :-))
  (<- (max-slot-size btr::plate table-setting 0.8d0))
  (<- (min-slot-size btr::plate table-setting 0.5d0))
  (<- (position-deviation-threshold btr::plate table-setting 0.03d0)))