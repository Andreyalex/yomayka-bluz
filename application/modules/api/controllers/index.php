<?php
/**
 * @author   Dmitriy Rassadkin
 * @created  26.09.14 12:29
 */

/**
 * @namespace
 */
namespace Application;

use Application\Auth\Table;
use Bluz\Proxy\Auth;

return
/**
 * @route /api/{$resource}
 *
 * @param string $resource
 *
 * @return \closure
 */
function ($resource) {
    /**
     * @var Bootstrap $this
     */
    $this->useJson();

    Auth::clearIdentity();

    try {
        // authentication
        if ($token = $this->getRequest()->getParam('token')) {
            Table::getInstance()->authenticateToken($token);
        }

        return $this->dispatch('api', $resource);
    } catch (\Exception $e) {
        // process exceptions here
        $this->getResponse()->setStatusCode($e->getCode());
        return (object)['error' => $e->getMessage()];
    }
};